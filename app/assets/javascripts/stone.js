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

var Dot = function(x, y) {
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
  this.stoneRadius = 9;
  this.width = this.pixelsPerSquare * this.squareSideLength;
  this.height = this.pixelsPerSquare * this.squareSideLength;
  this.acceleration = 0.002;
  this.elasticity = 0.8;
  this.millisecondsPerSecond = 1000;
  this.framesPerSecond = 20;
  this.stepMilliseconds = this.millisecondsPerSecond / this.framesPerSecond;
  this.accelerationPerFrame = this.acceleration * this.stepMilliseconds;
  this.collisionThreshold = this.accelerationPerFrame * 1.1;

  this.rectangles = [];
  this.lines = [];
  this.dots = [];
  this.stones = [];
};

Board2.prototype.display = function(){
  var board = this;

  this.canvas = d3.select("#board-container").append("svg").attr("height", this.height + "px").attr("width", this.width + "px");

  this.addRectangle(new Rectangle(0, 0, 19, 19));

  this.displayRectangles();

  for(i=0; i<19; i++){
    this.addLine(new Line(i, 0, 18, "horizontal"));
    this.addLine(new Line(i, 0, 18, "vertical"));
  }

  this.displayLines();

  [3, 9, 15].forEach(function (x) {
    [3, 9, 15].forEach(function (y) {
      board.addDot(new Dot(x, y));
    });
  });

  this.displayDots();

  $('svg').click(function(e) { board.onClick(this, e); } );
  $('#endgame').click(function(e) { board.animate(); } );
};

Board2.prototype.addStone = function(stone){
  this.stones.push(stone);
};

Board2.prototype.addLine = function(line){
  this.lines.push(line);
};

Board2.prototype.addDot = function(dot){
  this.dots.push(dot);
};

Board2.prototype.addRectangle = function(rectangle){
  this.rectangles.push(rectangle);
};

Board2.prototype.offsetToPixels = function(offset){
  return (offset + 0.5) * this.pixelsPerSquare;
};

Board2.prototype.animate = function() {
  var board = this;
  // add random x velocity to stones
  
  this.stones.forEach(function(stone){
    var horizontalMovement = 0.05
    stone.vx = (Math.random() - 0.5) * horizontalMovement * board.stepMilliseconds;
  });

  this.animateInterval = setInterval(function(){ board.dropStones(); }, this.stepMilliseconds);
};

Board2.prototype.onClick = function(clickee, e) {
  var square = this.mouseCoordToSquare(e.pageX - $(clickee).offset().left, e.pageY - $(clickee).offset().top);
  if (this.closeToSquare(square[0], square[1])) {
    this.submitTurn(Math.round(square[0]), Math.round(square[1]));
  }
};

Board2.prototype.mouseCoordToSquare = function(x, y) {
  var squareX = (x / this.pixelsPerSquare) - 0.5; 
  var squareY = (y / this.pixelsPerSquare) - 0.5;

  return [squareX, squareY];
};

Board2.prototype.closeToSquare = function(x, y) {
  if ( Math.abs(x - Math.round(x)) < 0.25 && Math.abs(y - Math.round(y)) < 0.25) {
    return true;
  } else {
    return false;
  }
};

Board2.prototype.submitTurn = function(x, y) {
  $('#turn').children('#row').val(y);
  $('#turn').children('#column').val(x);
  $('#turn').submit();
};

Board2.prototype.dropStones = function(){
    this.doPhysics();

    this.updateStones();

    if(this.stones.every(function(stone) {
      return board.atRest(stone) && board.groundCollision(stone) && !board.movingUp(stone);
    })){
      // TODO stop
      //clearInterval(this.animateInterval);
    }
};

Board2.prototype.doPhysics = function(){
  var board = this;

  this.stones.forEach(function(stone) {
    board.doPhysicsToStone(stone);
  });

  this.handleStoneCollisions();

  this.stones.forEach(function(stone) {
    board.handleWallCollisions(stone);
  });
}

Board2.prototype.doPhysicsToStone = function(stone) {
  this.applyGravity(stone);
  this.applyVelocity(stone);
};

Board2.prototype.handleWallCollisions = function(stone) {
  this.handleLeftWallCollision(stone);
  this.handleRightWallCollision(stone);
  this.handleGroundCollision(stone);
};

Board2.prototype.applyGravity = function(stone) {
  stone.vy += board.accelerationPerFrame;
};

Board2.prototype.handleGroundCollision = function(stone) {
  if(this.groundCollision(stone) && !this.movingUp(stone)){
    if(this.atRest(stone)){
      this.stopStone(stone);
      this.moveStoneToGround(stone);
    } else{
      this.bounceStone(stone);
    }
  }
};

Board2.prototype.handleLeftWallCollision = function(stone) {
  if(this.leftWallCollision(stone) && !this.movingRight(stone)){
    this.bounceStoneLeft(stone);
  }
};

Board2.prototype.handleRightWallCollision = function(stone) {
  if(this.rightWallCollision(stone) && !this.movingLeft(stone)){
    this.bounceStoneRight(stone);
  }
};

Board2.prototype.applyVelocity = function(stone) {
  stone.x += stone.vx;
  stone.y += stone.vy;
};

Board2.prototype.handleStoneCollisions = function() {
  for(i=0; i<this.stones.length; i++){
    var stone = this.stones[i];

    for(j=i+1; j<this.stones.length; j++){
      var otherStone = this.stones[j];

      board.collideStones(stone, otherStone);
    }
  }
};

Board2.prototype.collideStones = function(stone1, stone2){
  var circle1 = [board.offsetToPixels(stone1.x), board.offsetToPixels(stone1.y)];
  var circle2 = [board.offsetToPixels(stone2.x), board.offsetToPixels(stone2.y)];

  var xDistance = circle1[0] - circle2[0];
  var yDistance = circle1[1] - circle2[1];

  var totalDistance = Math.sqrt(xDistance*xDistance + yDistance*yDistance);

  if(totalDistance <= this.stoneRadius){
    //console.log("collision " + totalDistance);
  }
};

Board2.prototype.stopStone = function(stone){
  stone.vy = 0;
};

Board2.prototype.moveStoneToGround = function(stone){
  stone.y = this.squareSideLength - 1;
};

Board2.prototype.bounceStoneLeft = function(stone){
  this.pretendItBouncedLeft(stone);
  stone.vx = stone.vx * -1 * this.elasticity;
};

Board2.prototype.pretendItBouncedLeft = function(stone){
  // TODO put ground depth as a variable
  var distanceToLeftWall = stone.x + stone.vx;

  stone.x = distanceToLeftWall / this.elasticity;
};

Board2.prototype.bounceStoneRight = function(stone){
  this.pretendItBouncedRight(stone);
  stone.vx = stone.vx * -1 * this.elasticity;
};

Board2.prototype.pretendItBouncedRight = function(stone){
  // TODO put ground depth as a variable
  var distanceToRightWall = stone.x + stone.vx - (this.squareSideLength - 1);

  stone.x = distanceToRightWall / this.elasticity + this.squareSideLength - 1;
};

Board2.prototype.bounceStone = function(stone){
  this.pretendItBounced(stone);
  stone.vy = stone.vy * -1 * this.elasticity;
};

Board2.prototype.pretendItBounced = function(stone){
  // TODO put ground depth as a variable
  var distanceToGround = stone.y + stone.vy - (this.squareSideLength - 1);

  stone.y = distanceToGround / this.elasticity + this.squareSideLength - 1;
};

Board2.prototype.groundCollision = function(stone){
  return stone.y + stone.vy >= (this.squareSideLength - 1) * 0.99;
};

Board2.prototype.leftWallCollision = function(stone){
  var futureX = stone.x + stone.vx;
  return futureX <= (this.squareSideLength - 1) * 0.01;
};

Board2.prototype.rightWallCollision = function(stone){
  var futureX = stone.x + stone.vx;
  return futureX >= (this.squareSideLength - 1) * 0.99;
};

Board2.prototype.movingLeft = function(stone){
  return stone.vx < 0;
};

Board2.prototype.movingRight = function(stone){
  return stone.vx > 0;
};

Board2.prototype.movingUp = function(stone){
  return stone.vy < 0;
};

Board2.prototype.movingDown = function(stone){
  return stone.vy > 0;
};

Board2.prototype.atRest = function(stone){
  return Math.abs(stone.vy) < this.collisionThreshold;
};

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

Board2.prototype.dotsToSampleData = function(dots){
  var board = this;
  return dots.map(function(dot) {
    return {
      cx: board.offsetToPixels(dot.x),
      cy: board.offsetToPixels(dot.y),
      rx: dot.rx,
      ry: dot.ry
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
  };

Board2.prototype.displayDots = function(){
    var groups = this.canvas.selectAll("g.dot")
      .data(this.dotsToSampleData(this.dots))
      .enter()
      .append("g")
      .attr("class", "dot")

    groups.append("ellipse")
      .attr("cx", function(d) { return d.cx })
      .attr("cy", function(d) { return d.cy })
      .attr("rx", 3)
      .attr("ry", 3)
      .attr("fill", "#000000");
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
      .attr("rx", this.stoneRadius)
      .attr("ry", this.stoneRadius)
      .attr("fill", function(d) { return d.bgcolor; });

    groups.append("ellipse")
      .attr("cx", 0)
      .attr("cy", 0)
      .attr("rx", this.stoneRadius - 1)
      .attr("ry", this.stoneRadius - 1)
      .attr("fill", function(d) { return d.fgcolor; });
  }

Board2.prototype.updateStones = function(){
    this.canvas.selectAll("g.stone")
    .data(this.stonesToSampleData(this.stones))
    .transition()
    .duration(board.stepMilliseconds)
    .ease("linear")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });
  }
