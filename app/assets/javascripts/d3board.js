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

var Board = function() {
  this.column_width = 25;
  this.row_height = 25;
  this.column_count = 19;
  this.row_count = 19;
  this.board_width = this.column_width * this.column_count;
  this.board_height = this.row_height * this.row_count;
};

Board.prototype.display = function() {
  var board = this;
  var board_display = d3.select("#board-container").append("svg").attr("height", "475px").attr("width", "475px");
  board_display.append("rect").attr({width: this.board_width, height: this.board_height, x: 0, y: 0, fill: "#E09E48"});

  for(var i=0; i<this.row_count; i++){
    board_display.append("line")
    .attr({
      x1: this.column_width / 2,
      x2: this.board_width - (this.column_width / 2),
      y1: (i + 0.5) * this.row_height,
      y2: (i + 0.5) * this.row_height,
      stroke: "#000000",
      "stroke-width": 1
    });
  }

  for(var i=0; i<this.column_count; i++){
    board_display.append("line")
    .attr({
      y1: this.column_width / 2,
      y2: this.board_width - (this.column_width / 2),
      x1: (i + 0.5) * this.column_width,
      x2: (i + 0.5) * this.column_width,
      stroke: "#000000",
      "stroke-width": 1
    });
  }

  [3, 9, 15].forEach(function (x){
    [3, 9, 15].forEach(function (y){
      board_display.append("ellipse")
      .attr({
        cx: (x + 0.5) * board.column_width,
        cy: (y + 0.5) * board.row_height,
        rx: 3,
        ry: 3,
        fill: "#000000"
      });
    });
  });

  $('svg').click(function(e) { board.onClick(this, e) } );

  this.board_display = board_display;
};

Board.prototype.placeStone = function(coordinate, color) {
  var x = coordinate.column;
  var y = coordinate.row;

  this.board_display.append("ellipse")
  .attr({
    cx: x*25+12.5,
    cy: y*25+12.5,
    rx: 9,
    ry: 9,
    fill: color.other().to_s()
  });

  this.board_display.append("ellipse")
  .attr({
    cx: x*25+12.5,
    cy: y*25+12.5,
    rx: 8,
    ry: 8,
    fill: color.to_s()
  });
};

Board.prototype.onClick = function(clickee, e) {
  var square = this.mouseCoordToSquare(e.pageX - $(clickee).offset().left, e.pageY - $(clickee).offset().top);
  if(this.closeToSquare(square[0], square[1])) {
    this.submitTurn(Math.round(square[0]), Math.round(square[1]));
  }
};

Board.prototype.submitTurn = function(x, y) {
  $('#turn').children('#row').val(y);
  $('#turn').children('#column').val(x);
  $('#turn').submit();
};

Board.prototype.closeToSquare = function(x, y) {
  if( Math.abs(x - Math.round(x)) < 0.25 && Math.abs(y - Math.round(y)) < 0.25) {
    return true;
  }
  else {
    return false;
  }
};

Board.prototype.mouseCoordToSquare = function(x, y) {
  var squareX = (x - 12.5) / 25; 
  var squareY = (y - 12.5) / 25;

  return [squareX, squareY];
}
