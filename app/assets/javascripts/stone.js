var Stone = function(x, y, color) {
  this.cx = x;
  this.cy = y;
  this.color = color;
  this.vx = 0;
  this.vy = 0;
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

  var stones = [];

  stones.push(new Stone(20, 20, 'black'));
  stones.push(new Stone(40, 20, 'black'));
  stones.push(new Stone(60, 20, 'black'));

  var data = [
      {cx: 5, cy: 5, rx: 5, ry: 5, vx: 0, vy: 0, fgcolor: "#000000", bgcolor: "#ff00ff"},
      {cx: 25, cy: 5, rx: 5, ry: 5, vx: 0, vy: 0, fgcolor: "#000000", bgcolor: "#ff00ff"},
      {cx: 55, cy: 5, rx: 5, ry: 5, vx: 0, vy: 0, fgcolor: "#000000", bgcolor: "#ff00ff"},
    ];

  function initBoard2(){
    board_display = d3.select("#board-container").append("svg").attr("height", board_height + "px").attr("width", board_width + "px");

    $("svg").click(clickToAddStone);

    drawStones(stones);
  }

  function animate() {
    setInterval(dropStones, stepMilliseconds);
  }

  function dropStones(){
    doPhysics();

    updateStones();
  }

  function clickToAddStone(e){
    var cx = e.pageX - $(this).offset().left; 
    var cy = e.pageY - $(this).offset().top;
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
    return stone.cy >= board_height - 200;
  }

  function movingDown(stone){
    return stone.vy > 0;
  }

  function atRest(stone){
    return Math.abs(stone.vy) < collisionThreshold;
  }

  function stonesToSampleData(stones){
    return stones.map(function(stone) {
      return {cx: stone.cx, cy: stone.cy, rx: 5, ry: 5, fgcolor: "#000000", bgcolor: "#ff00ff"};
    });
  }

  function drawStones(stones){
    var groups = board_display.selectAll("g")
      .data(stonesToSampleData(stones))
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

  function updateStones(){
    board_display.selectAll("g")
    .data(stonesToSampleData(stones))
    .transition()
    .duration(100)
    .ease("linear")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });
  }
