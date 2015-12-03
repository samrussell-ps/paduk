var Stones = function() {
  this.stones = [];
};

Stones.prototype.addStone = function(x, y, color) {
  this.stones.push({x: x, y: y, color: color});
};

  var board_display;
  var board_width = 475;
  var board_height = 475;
  var acceleration = 0.15;
  var elasticity = 0.9;
  var millisecondsPerSecond = 1000;
  var framesPerSecond = 50;
  var stepMilliseconds = millisecondsPerSecond / framesPerSecond;
  var accelerationPerFrame = acceleration * stepMilliseconds;
  var collisionThreshold = accelerationPerFrame * 1.1;

  var data = [
      {cx: 5, cy: 5, rx: 5, ry: 5, vx: 0, vy: 0, fgcolor: "#000000", bgcolor: "#ff00ff"},
      {cx: 25, cy: 5, rx: 5, ry: 5, vx: 0, vy: 0, fgcolor: "#000000", bgcolor: "#ff00ff"},
      {cx: 55, cy: 5, rx: 5, ry: 5, vx: 0, vy: 0, fgcolor: "#000000", bgcolor: "#ff00ff"},
    ];

  function initBoard2(){
    board_display = d3.select("#board-container").append("svg").attr("height", board_height + "px").attr("width", board_width + "px");

    drawStones(data);
  }

  function animate() {
    setInterval(dropStones, stepMilliseconds);
  }

  function dropStones(){
    doPhysics();

    updateStones(data);
  }

  function doPhysics(){
    calculateCollisions(data);

    data.forEach(function(stoneData) {
      doPhysicsToStone(stoneData);
    });
  }

  function doPhysicsToStone(stoneData) {
    applyGravity(stoneData);
    applyVelocity(stoneData);
  }

  function applyGravity(stoneData) {
    if(!groundCollision(stoneData) || !atRest(stoneData)){
      stoneData.vy += accelerationPerFrame;
    }
  }

  function applyVelocity(stoneData) {
    stoneData.cx += stoneData.vx;
    stoneData.cy += stoneData.vy;
  }

  function calculateCollisions(data){
    data.forEach(function(stoneData) {
      calculateGroundCollision(stoneData);
    });
  }

  function calculateGroundCollision(stoneData){
    if(groundCollision(stoneData)) {
      if(movingDown(stoneData)){
        if(atRest(stoneData)){
          stopStone(stoneData);
        } else {
          bounceStone(stoneData);
        }
      }
    }
  }

  function stopStone(stoneData){
    stoneData.vy = 0;
  }

  function bounceStone(stoneData){
    stoneData.vy = stoneData.vy * -1 * elasticity;
  }

  function groundCollision(stoneData){
    return stoneData.cy >= board_height - 200;
  }

  function movingDown(stoneData){
    return stoneData.vy > 0;
  }

  function atRest(stoneData){
    return Math.abs(stoneData.vy) < collisionThreshold;
  }

  function drawStones(sample_data){
    var groups = board_display.selectAll("g")
      .data(sample_data)
      .enter()
      .append("g")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });

    groups.append("ellipse")
      .attr("cx", function(d) { return 0; })
      .attr("cy", function(d) { return 0; })
      .attr("rx", function(d) { return 5; })
      .attr("ry", function(d) { return 5; })
      .attr("fill", function(d) { return d.bgcolor; });

    groups.append("ellipse")
      .attr("cx", function(d) { return 0; })
      .attr("cy", function(d) { return 0; })
      .attr("rx", function(d) { return 3; })
      .attr("ry", function(d) { return 3; })
      .attr("fill", function(d) { return d.fgcolor; });
  }

  function updateStones(sample_data){
    board_display.selectAll("g")
    .data(sample_data)
    .transition()
    .duration(100)
    .ease("linear")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });
  }
