var Stone = function(x, y, color) {
  this.x = x;
  this.y = y;
  this.color = color;
  this.vx = 0;
  this.vy = 0;
};

Stone.prototype.setCoord = function(x, y){
  this.x = x;
  this.y = y;
};

var Line = function(offset, start, finish, orientation) {
  if(orientation == "horizontal"){
    this.x1 = start;
    this.x2 = finish;
    this.y1 = offset;
    this.y2 = offset;
  } else if(orientation == "vertical"){
    this.x1 = offset;
    this.x2 = offset;
    this.y1 = start;
    this.y2 = finish;
  }
};

var Rectangle = function(x, y, width, height) {
  this.x = x;
  this.y = y;
  this.width = width;
  this.height = height;
};

var Board2 = function() {
  this.canvas;
  this.pixelsPerSquare = 25;
  this.squareSideLength = 19;
  this.width = this.pixelsPerSquare * this.squareSideLength;
  this.height = this.pixelsPerSquare * this.squareSideLength;
  this.acceleration = 0.002;
  this.elasticity = 0.9;
  this.millisecondsPerSecond = 1000;
  this.framesPerSecond = 50;
  this.stepMilliseconds = this.millisecondsPerSecond / this.framesPerSecond;
  this.accelerationPerFrame = this.acceleration * this.stepMilliseconds;
  this.collisionThreshold = this.accelerationPerFrame * 1.1;

  this.rectangles = [];
  this.lines = [];
  this.stones = [];
};

Board2.prototype.display = function(){
  this.canvas = d3.select("#board-container").append("svg").attr("height", this.height + "px").attr("width", this.width + "px");

  this.addRectangle(new Rectangle(0, 0, 19, 19));

  this.displayRectangles();

  for(i=0; i<19; i++){
    this.addLine(new Line(i, 0, 18, "horizontal"));
    this.addLine(new Line(i, 0, 18, "vertical"));
  }

  this.displayLines();

  //$("svg").click(clickToAddStone);
};

Board2.prototype.addStone = function(stone){
  this.stones.push(stone);
};

Board2.prototype.addLine = function(line){
  this.lines.push(line);
};

Board2.prototype.addRectangle = function(rectangle){
  this.rectangles.push(rectangle);
};

Board2.prototype.offsetToPixels = function(offset){
  return (offset + 0.5) * this.pixelsPerSquare;
};

Board2.prototype.animate = function() {
  var board = this;
  setInterval(function(){ board.dropStones(); }, this.stepMilliseconds);
};

Board2.prototype.dropStones = function(){
    doPhysics(this.stones);

    this.updateStones();
};

  function doPhysics(stones){
    stones.forEach(function(stone) {
      doPhysicsToStone(stone);
    });
  }

  function doPhysicsToStone(stone) {
    applyGravity(stone);
    applyVelocity(stone);
  }

  function applyGravity(stone) {
    if(!groundCollision(stone) || !atRest(stone)){
      stone.vy += board.accelerationPerFrame;
    }
  }

  function applyVelocity(stone) {
    if(!groundCollision(stone)){
    stone.x += stone.vx;
    stone.y += stone.vy;
    }
  }

  function calculateCollisions(stones){
    stones.forEach(function(stone) {
      calculateGroundCollision(stone);
    });
  }

  function calculateGroundCollision(stone){
    if(groundCollision(stone)) {
      if(movingDown(stone)){
        if(atRest(stone)){
          stopStone(stone);
        } else {
          bounceStone(stone);
        }
      }
    }
  }

  function stopStone(stone){
    stone.vy = 0;
  }

  function bounceStone(stone){
    stone.vy = stone.vy * -1 * elasticity;
  }

  function groundCollision(stone){
    return stone.y >= board.squareSideLength - 1;
  }

  function movingDown(stone){
    return stone.vy > 0;
  }

  function atRest(stone){
    return Math.abs(stone.vy) < board.collisionThreshold;
  }

Board2.prototype.stonesToSampleData = function(stones){
  var board = this;
  return stones.map(function(stone) {
    return {cx: board.offsetToPixels(stone.x), cy: board.offsetToPixels(stone.y), fgcolor: stone.color.to_s(), bgcolor: stone.color.other().to_s()};
  });
};

Board2.prototype.linesToSampleData = function(lines){
  var board = this;
  return lines.map(function(line) {
    return {
      x1: board.offsetToPixels(line.x1),
      x2: board.offsetToPixels(line.x2),
      y1: board.offsetToPixels(line.y1),
      y2: board.offsetToPixels(line.y2)
    };
  });
};

Board2.prototype.rectanglesToSampleData = function(rectangles){
  var board = this;
  return rectangles.map(function(rectangle) {
    return {
      x: rectangle.x * board.pixelsPerSquare,
      y: rectangle.y * board.pixelsPerSquare,
      width: rectangle.width * board.pixelsPerSquare,
      height: rectangle.height * board.pixelsPerSquare
    };
  });
};

Board2.prototype.displayRectangles = function(){
    var groups = this.canvas.selectAll("g.rectangle")
      .data(this.rectanglesToSampleData(this.rectangles))
      .enter()
      .append("g")
      .attr("class", "rectangle")

    groups.append("rect")
      .attr("x", function(d) { return d.x })
      .attr("y", function(d) { return d.y })
      .attr("width", function(d) { return d.width })
      .attr("height", function(d) { return d.height })
      .attr("fill", "#E09E48");
  }

Board2.prototype.displayLines = function(){
    var groups = this.canvas.selectAll("g.line")
      .data(this.linesToSampleData(this.lines))
      .enter()
      .append("g")
      .attr("class", "line")

    groups.append("line")
      .attr("x1", function(d) { return d.x1 })
      .attr("x2", function(d) { return d.x2 })
      .attr("y1", function(d) { return d.y1 })
      .attr("y2", function(d) { return d.y2 })
      .attr("stroke", "#000000")
      .attr("stroke-width", 1);
  }

Board2.prototype.displayStones = function(){
    var groups = this.canvas.selectAll("g.stone")
      .data(this.stonesToSampleData(this.stones))
      .enter()
      .append("g")
      .attr("class", "stone")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });

    groups.append("ellipse")
      .attr("cx", 0)
      .attr("cy", 0)
      .attr("rx", 9)
      .attr("ry", 9)
      .attr("fill", function(d) { return d.bgcolor; });

    groups.append("ellipse")
      .attr("cx", 0)
      .attr("cy", 0)
      .attr("rx", 8)
      .attr("ry", 8)
      .attr("fill", function(d) { return d.fgcolor; });
  }

Board2.prototype.updateStones = function(){
    this.canvas.selectAll("g.stone")
    .data(this.stonesToSampleData(this.stones))
    .transition()
    .duration(100)
    .ease("linear")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });
  }
