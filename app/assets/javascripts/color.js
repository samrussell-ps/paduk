var Color = function(colorString) {
  this.colorString = colorString;
};

Color.prototype.to_s = function() {
  switch(this.colorString) {
    case "white":
      return "#ffffff";
    case "black":
      return "#000000";
  }
  return null;
};

Color.prototype.other = function() {
  switch(this.colorString) {
    case "white":
      return new Color("black");
    case "black":
      return new Color("white");
  }
  return new Color(null);
};
