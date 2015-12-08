var Stone = function(x, y, color) {
  this.x = x;
  this.y = y;
  this.color = color;
  this.vx = 0;
  this.vy = 0;
  this.radius = 0.4;
};

Stone.prototype.setCoord = function(x, y){
  this.x = x;
  this.y = y;
};

Stone.prototype.velocityMagnitude = function(){
  return this.velocityAsVector().magnitude();
}

Stone.prototype.positionAsVector = function(){
  return new Vector(this.x, this.y);
}

Stone.prototype.velocityAsVector = function(){
  return new Vector(this.vx, this.vy);
}
