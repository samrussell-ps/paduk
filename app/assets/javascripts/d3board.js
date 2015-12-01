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

Board.prototype.drawLine = function(x1, x2, y1, y2) {
  this.board_display.append("line")
    .attr({
      x1: x1,
      x2: x2,
      y1: y1,
      y2: y2,
      stroke: "#000000",
      "stroke-width": 1
    });
};

Board.prototype.display = function() {
  var board = this;

  this.board_display = d3.select("#board-container").append("svg").attr("height", this.board_height + "px").attr("width", this.board_width + "px");

  this.board_display.append("rect").attr({width: this.board_width, height: this.board_height, x: 0, y: 0, fill: "#E09E48"});

  for (var i=0; i<this.row_count; i++) {
    var x1 = this.column_width / 2;
    var x2 = this.board_width - (this.column_width / 2);
    var y1 = (i + 0.5) * this.row_height;
    var y2 = (i + 0.5) * this.row_height;

    board.drawLine(x1, x2, y1, y2);
  }

  for (var i=0; i<this.column_count; i++) {
    var x1 = (i + 0.5) * this.column_width;
    var x2 = (i + 0.5) * this.column_width;
    var y1 = this.column_width / 2;
    var y2 = this.board_width - (this.column_width / 2);

    board.drawLine(x1, x2, y1, y2);
  }

  [3, 9, 15].forEach(function (x) {
    [3, 9, 15].forEach(function (y) {
      board.board_display.append("ellipse")
      .attr({
        cx: (x + 0.5) * board.column_width,
        cy: (y + 0.5) * board.row_height,
        rx: 3,
        ry: 3,
        fill: "#000000"
      });
    });
  });

  $('svg').click(function(e) { board.onClick(this, e); } );
};

Board.prototype.placeStone = function(coordinate, color) {
  var x = coordinate.column;
  var y = coordinate.row;

  this.board_display.append("ellipse")
  .attr({
    cx: (x + 0.5) * this.column_width,
    cy: (y + 0.5) * this.row_height,
    rx: 9,
    ry: 9,
    fill: color.other().to_s()
  });

  this.board_display.append("ellipse")
  .attr({
    cx: (x + 0.5) * this.column_width,
    cy: (y + 0.5) * this.row_height,
    rx: 8,
    ry: 8,
    fill: color.to_s()
  });
};

Board.prototype.onClick = function(clickee, e) {
  var square = this.mouseCoordToSquare(e.pageX - $(clickee).offset().left, e.pageY - $(clickee).offset().top);
  if (this.closeToSquare(square[0], square[1])) {
    this.submitTurn(Math.round(square[0]), Math.round(square[1]));
  }
};

Board.prototype.submitTurn = function(x, y) {
  $('#turn').children('#row').val(y);
  $('#turn').children('#column').val(x);
  $('#turn').submit();
};

Board.prototype.closeToSquare = function(x, y) {
  if ( Math.abs(x - Math.round(x)) < 0.25 && Math.abs(y - Math.round(y)) < 0.25) {
    return true;
  } else {
    return false;
  }
};

Board.prototype.mouseCoordToSquare = function(x, y) {
  var squareX = (x / this.column_width) - 0.5; 
  var squareY = (y / this.row_height) - 0.5;

  return [squareX, squareY];
};
