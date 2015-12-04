var Stone = function(x, y, color) {
  this.cx = x * 25 + 12.5;
  this.cy = y * 25 + 12.5;
  this.color = color;
  this.vx = 0;
  this.vy = 0;
};

Stone.prototype.setCoord = function(x, y){
  this.cx = x * 25 + 12.5;
  this.cy = y * 25 + 12.5;
};

var Board2 = function() {
  this.canvas;
  this.column_width = 25;
  this.row_height = 25;
  this.column_count = 19;
  this.row_count = 19;
  this.width = this.column_width * this.column_count;
  this.height = this.row_height * this.row_count;
  this.acceleration = 0.15;
  this.elasticity = 0.9;
  this.millisecondsPerSecond = 1000;
  this.framesPerSecond = 50;
  this.stepMilliseconds = this.millisecondsPerSecond / this.framesPerSecond;
  this.accelerationPerFrame = this.acceleration * this.stepMilliseconds;
  this.collisionThreshold = this.accelerationPerFrame * 1.1;

  this.stones = [];
};

Board2.prototype.display = function(){
  this.canvas = d3.select("#board-container").append("svg").attr("height", this.height + "px").attr("width", this.width + "px");

  //$("svg").click(clickToAddStone);

  //drawStones(this.stones);
};

Board2.prototype.addStone = function(stone){
  this.stones.push(stone);
  this.displayStones();
};
/*
  function animate() {
    setInterval(dropStones, stepMilliseconds);
  }

  function dropStones(){
    doPhysics();

    updateStones();
  }

  function clickToAddStone(e){
    var x = e.pageX - $(this).offset().left; 
    var y = e.pageY - $(this).offset().top;
    var cx = x/25 - 0.5;
    var cy = y/25 - 0.5;
    stones.push(new Stone(cx, cy, 'black'));

    drawStones(stones);
  }

  function doPhysics(){
    calculateCollisions(stones);

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
      stone.vy += accelerationPerFrame;
    }
  }

  function applyVelocity(stone) {
    stone.cx += stone.vx;
    stone.cy += stone.vy;
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
    return stone.cy >= board_height;
  }

  function movingDown(stone){
    return stone.vy > 0;
  }

  function atRest(stone){
    return Math.abs(stone.vy) < collisionThreshold;
  }
*/
  function stonesToSampleData(stones){
    return stones.map(function(stone) {
      return {cx: stone.cx, cy: stone.cy, fgcolor: "#03A9F4", bgcolor: "#F44336"};
    });
  }

Board2.prototype.displayStones = function(){
    var groups = this.canvas.selectAll("g.stone")
      .data(stonesToSampleData(this.stones))
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
      .attr("rx", 7)
      .attr("ry", 7)
      .attr("fill", function(d) { return d.fgcolor; });
  }

Board2.prototype.updateStones = function(){
    this.canvas.selectAll("g.stone")
    .data(stonesToSampleData(this.stones))
    .transition()
    .duration(100)
    .ease("linear")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });
  }
