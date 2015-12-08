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
