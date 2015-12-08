var Vector = function(x, y) {
  this.x = x;
  this.y = y;
};

Vector.prototype.magnitude = function(){
  return Math.sqrt(this.x*this.x + this.y*this.y);
};

Vector.prototype.toUnitVector = function(){
  return new Vector(this.x / this.magnitude(), this.y / this.magnitude());
};

Vector.prototype.dotProduct = function(otherVector){
  return this.x*otherVector.x + this.y*otherVector.y;
};
