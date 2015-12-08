var Board = function() {
  this.canvas;
  this.pixelsPerSquare = 25;
  this.squareSideLength = 19;
  this.maximumStoneOffset = this.squareSideLength - 1;
  this.stoneRadius = 9;
  this.width = this.pixelsPerSquare * this.squareSideLength;
  this.height = this.pixelsPerSquare * this.squareSideLength;
  this.acceleration = 0.002;
  this.elasticity = 0.8;
  this.millisecondsPerSecond = 1000;
  this.framesPerSecond = 60;
  this.stepMilliseconds = this.millisecondsPerSecond / this.framesPerSecond;
  this.accelerationPerFrame = this.acceleration * this.stepMilliseconds;
  this.collisionThreshold = this.accelerationPerFrame * 1.1;

  this.rectangles = [];
  this.lines = [];
  this.dots = [];
  this.stones = [];
};

Board.prototype.display = function(){
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

Board.prototype.addStone = function(stone){
  this.stones.push(stone);
};

Board.prototype.addLine = function(line){
  this.lines.push(line);
};

Board.prototype.addDot = function(dot){
  this.dots.push(dot);
};

Board.prototype.addRectangle = function(rectangle){
  this.rectangles.push(rectangle);
};

Board.prototype.offsetToPixels = function(offset){
  return (offset + 0.5) * this.pixelsPerSquare;
};

Board.prototype.radiusToPixels = function(radius){
  return radius * this.pixelsPerSquare;
};

Board.prototype.animate = function() {
  var board = this;

  this.addRandomXVelocityToStones();
  
  this.animateInterval = setInterval(function(){ board.dropStones(); }, this.stepMilliseconds);
};

Board.prototype.addRandomXVelocityToStones = function() {
  this.stones.forEach(function(stone){
    var horizontalMovement = 0.01
    stone.vx = (Math.random() - 0.5) * horizontalMovement * board.stepMilliseconds;
  });
};

Board.prototype.onClick = function(clickee, e) {
  var square = this.mouseCoordToSquare(e.pageX - $(clickee).offset().left, e.pageY - $(clickee).offset().top);
  if (this.closeToSquare(square[0], square[1])) {
    this.submitTurn(Math.round(square[0]), Math.round(square[1]));
  }
};

Board.prototype.mouseCoordToSquare = function(x, y) {
  var squareX = (x / this.pixelsPerSquare) - 0.5; 
  var squareY = (y / this.pixelsPerSquare) - 0.5;

  return [squareX, squareY];
};

Board.prototype.closeToSquare = function(x, y) {
  return Math.abs(x - Math.round(x)) < 0.25 && Math.abs(y - Math.round(y)) < 0.25;
};

Board.prototype.submitTurn = function(x, y) {
  $('#turn').children('#row').val(y);
  $('#turn').children('#column').val(x);
  $('#turn').submit();
};

Board.prototype.dropStones = function(){
    this.doPhysics();

    this.updateStones();

    if(this.stones.every(function(stone) {
      return board.atRest(stone) && board.groundCollision(stone) && !board.movingUp(stone);
      //return stone.x < 0 || stone.x > this.maximumStoneOffset;
    })){
      console.log("done animating");
      clearInterval(this.animateInterval);
    }
};

Board.prototype.doPhysics = function(){
  var board = this;

  this.stones.forEach(function(stone) {
    board.doPhysicsToStone(stone);
  });

  this.handleStoneCollisions();

  this.stones.forEach(function(stone) {
    board.handleWallCollisions(stone);
  });
}

Board.prototype.doPhysicsToStone = function(stone) {
  this.applyGravity(stone);
  this.applyVelocity(stone);
};

Board.prototype.handleWallCollisions = function(stone) {
  this.handleLeftWallCollision(stone);
  this.handleRightWallCollision(stone);
  this.handleGroundCollision(stone);
};

Board.prototype.applyGravity = function(stone) {
  stone.vy += board.accelerationPerFrame;
};

Board.prototype.handleGroundCollision = function(stone) {
  if(this.groundCollision(stone) && !this.movingUp(stone)){
    if(this.atRest(stone)){
      this.stopStone(stone);
      this.moveStoneToGround(stone);
    } else{
      this.bounceStone(stone);
    }
  }
};

Board.prototype.handleLeftWallCollision = function(stone) {
  if(this.leftWallCollision(stone) && !this.movingRight(stone)){
    this.bounceStoneLeft(stone);
  }
};

Board.prototype.handleRightWallCollision = function(stone) {
  if(this.rightWallCollision(stone) && !this.movingLeft(stone)){
    this.bounceStoneRight(stone);
  }
};

Board.prototype.applyVelocity = function(stone) {
  stone.x += stone.vx;
  stone.y += stone.vy;
};

Board.prototype.handleStoneCollisions = function() {
  for(i=0; i<this.stones.length; i++){
    var stone = this.stones[i];

    for(j=i+1; j<this.stones.length; j++){
      var otherStone = this.stones[j];

      board.collideStones(stone, otherStone);
    }
  }
};

Board.prototype.collideStones = function(stone1, stone2){
  //var circle1 = [this.offsetToPixels(stone1.x), this.offsetToPixels(stone1.y)];
  //var circle2 = [this.offsetToPixels(stone2.x), this.offsetToPixels(stone2.y)];
  var circle1 = [(stone1.x), (stone1.y)];
  var circle2 = [(stone2.x), (stone2.y)];

  var xDistance = circle1[0] - circle2[0];
  var yDistance = circle1[1] - circle2[1];

  var stone1stone2vector = [-xDistance, -yDistance];
  var stone2stone1vector = [xDistance, yDistance];

  var stone1VelocityMagnitude = Math.sqrt(stone1.vx*stone1.vx + stone1.vy*stone1.vy);
  var stone2VelocityMagnitude = Math.sqrt(stone2.vx*stone2.vx + stone2.vy*stone2.vy);

  var totalDistance = Math.sqrt(xDistance*xDistance + yDistance*yDistance);

  if(totalDistance <= stone1.radius + stone2.radius){
    var stone1VelocityCoefficient;
    if(stone1VelocityMagnitude != 0) {
      stone1VelocityCoefficient = this.dotProduct(stone1.vx, stone1.vy, stone1stone2vector[0], stone1stone2vector[1]) / (stone1VelocityMagnitude * totalDistance);
    } else {
      stone1VelocityCoefficient = 0;
    }
    var stone1VelocityUnitVector = this.unitVector(stone1stone2vector[0], stone1stone2vector[1]);
    var stone1VelocityVector = [stone1VelocityUnitVector[0] * stone1VelocityMagnitude, stone1VelocityUnitVector[1] * stone1VelocityMagnitude];
    var stone1VelocityToGive = [stone1VelocityCoefficient * stone1VelocityVector[0], stone1VelocityCoefficient * stone1VelocityVector[1]];

    var stone2VelocityCoefficient;
    if(stone2VelocityMagnitude != 0) {
      stone2VelocityCoefficient = this.dotProduct(stone2.vx, stone2.vy, stone2stone1vector[0], stone2stone1vector[1]) / (stone2VelocityMagnitude * totalDistance);
    } else {
      stone2VelocityCoefficient = 0;
    }
    var stone2VelocityUnitVector = this.unitVector(stone2stone1vector[0], stone2stone1vector[1]);
    var stone2VelocityVector = [stone2VelocityUnitVector[0] * stone2VelocityMagnitude, stone2VelocityUnitVector[1] * stone2VelocityMagnitude];
    var stone2VelocityToGive = [stone2VelocityCoefficient * stone2VelocityVector[0], stone2VelocityCoefficient * stone2VelocityVector[1]];

    //console.log("collision");
    //console.log("stone1VelocityCoefficient: " + stone1VelocityCoefficient);
    //console.log("stone2VelocityCoefficient: " + stone2VelocityCoefficient);
    //console.log("stone1VelocityUnitVector: " + stone1VelocityUnitVector);
    //console.log("stone2VelocityUnitVector: " + stone2VelocityUnitVector);
    //console.log("stone1VelocityToGive: " + stone1VelocityToGive);
    //console.log("stone2VelocityToGive: " + stone2VelocityToGive);
    //console.log("stone1stone2vector: " + stone1stone2vector);
    //console.log("stone2stone1vector: " + stone2stone1vector);

    // only collide if positive sum coefficients
    
    if(stone1VelocityCoefficient + stone2VelocityCoefficient > 0) {
      stone1.vx -= stone1VelocityToGive[0];
      stone2.vx += stone1VelocityToGive[0] * this.elasticity;
      stone1.vy -= stone1VelocityToGive[1];
      stone2.vy += stone1VelocityToGive[1] * this.elasticity;

      stone2.vx -= stone2VelocityToGive[0];
      stone1.vx += stone2VelocityToGive[0] * this.elasticity;
      stone2.vy -= stone2VelocityToGive[1];
      stone1.vy += stone2VelocityToGive[1] * this.elasticity;
    }
  }
};

Board.prototype.unitVector = function(x, y){
  var vectorLength = Math.sqrt(x*x + y*y);
  return [x / vectorLength, y / vectorLength];
};

Board.prototype.dotProduct = function(x1, y1, x2, y2){
  return x1*x2 + y1*y2;
};

Board.prototype.stopStone = function(stone){
  stone.vy = 0;
};

Board.prototype.moveStoneToGround = function(stone){
  stone.y = this.maximumStoneOffset;
};

Board.prototype.bounceStoneLeft = function(stone){
  this.pretendItBouncedLeft(stone);
  stone.vx = stone.vx * -1 * this.elasticity;
};

Board.prototype.pretendItBouncedLeft = function(stone){
  var distanceToLeftWall = stone.x + stone.vx;

  stone.x = distanceToLeftWall / this.elasticity;
};

Board.prototype.bounceStoneRight = function(stone){
  this.pretendItBouncedRight(stone);
  stone.vx = stone.vx * -1 * this.elasticity;
};

Board.prototype.pretendItBouncedRight = function(stone){
  var distanceToRightWall = stone.x + stone.vx - this.maximumStoneOffset;

  stone.x = distanceToRightWall / this.elasticity + this.maximumStoneOffset;
};

Board.prototype.bounceStone = function(stone){
  //this.pretendItBounced(stone);
  stone.vy = stone.vy * -1 * this.elasticity;
};

Board.prototype.pretendItBounced = function(stone){
  var distanceToGround = stone.y + stone.vy - this.maximumStoneOffset;

  stone.y = distanceToGround / this.elasticity + this.maximumStoneOffset;
};

Board.prototype.groundCollision = function(stone){
  return stone.y + stone.vy >= this.maximumStoneOffset * 0.99;
};

Board.prototype.leftWallCollision = function(stone){
  var futureX = stone.x + stone.vx;
  return futureX <= this.maximumStoneOffset * 0.01;
};

Board.prototype.rightWallCollision = function(stone){
  var futureX = stone.x + stone.vx;
  return futureX >= this.maximumStoneOffset * 0.99;
};

Board.prototype.movingLeft = function(stone){
  return stone.vx < 0;
};

Board.prototype.movingRight = function(stone){
  return stone.vx > 0;
};

Board.prototype.movingUp = function(stone){
  return stone.vy < 0;
};

Board.prototype.movingDown = function(stone){
  return stone.vy > 0;
};

Board.prototype.atRest = function(stone){
  return Math.sqrt(stone.vx*stone.vx + stone.vy*stone.vy) < this.collisionThreshold*2;
};

Board.prototype.stonesToSampleData = function(stones){
  var board = this;
  return stones.map(function(stone) {
    return {
      cx: board.offsetToPixels(stone.x),
      cy: board.offsetToPixels(stone.y),
      rx: board.radiusToPixels(stone.radius),
      ry: board.radiusToPixels(stone.radius),
      fgcolor: stone.color.to_s(),
      bgcolor: stone.color.other().to_s()
    };
  });
};

Board.prototype.linesToSampleData = function(lines){
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

Board.prototype.dotsToSampleData = function(dots){
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

Board.prototype.rectanglesToSampleData = function(rectangles){
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

Board.prototype.displayRectangles = function(){
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

Board.prototype.displayDots = function(){
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


Board.prototype.displayLines = function(){
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

Board.prototype.displayStones = function(){
    var groups = this.canvas.selectAll("g.stone")
      .data(this.stonesToSampleData(this.stones))
      .enter()
      .append("g")
      .attr("class", "stone")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });

    groups.append("ellipse")
      .attr("cx", 0)
      .attr("cy", 0)
      .attr("rx", function(d) { return d.rx; })
      .attr("ry", function(d) { return d.ry; })
      .attr("fill", function(d) { return d.bgcolor; });

    groups.append("ellipse")
      .attr("cx", 0)
      .attr("cy", 0)
      .attr("rx", function(d) { return d.rx * 0.9; })
      .attr("ry", function(d) { return d.ry * 0.9; })
      .attr("fill", function(d) { return d.fgcolor; });
  }

Board.prototype.updateStones = function(){
    this.canvas.selectAll("g.stone")
    .data(this.stonesToSampleData(this.stones))
    .transition()
    .duration(this.stepMilliseconds)
    .ease("linear")
      .attr("transform", function(d) { return "translate(" + d.cx + "," + d.cy + ")"; });
  }
