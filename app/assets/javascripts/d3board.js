function initBoard(turns){ 
  var board = d3.select("#board-container").append("svg").attr("height", "475px").attr("width", "475px");
  board.append("rect").attr({width: 500, height: 500, x: 0, y: 0, fill: "#E09E48"});

  for(var i=0; i<19; i++){
    board.append("line")
    .attr({
      x1: 12.5,
      x2: 475 - 12.5,
      y1: 25*i+12.5,
      y2: 25*i+12.5,
      stroke: "#000000",
      "stroke-width": 1
    });

    board.append("line")
    .attr({
      y1: 12.5,
      y2: 475 - 12.5,
      x1: 25*i+12.5,
      x2: 25*i+12.5,
      stroke: "#000000",
      "stroke-width": 1
    });
  }

  [3, 9, 15].forEach(function (x){
    [3, 9, 15].forEach(function (y){
      board.append("ellipse")
      .attr({
        cx: x*25+12.5,
        cy: y*25+12.5,
        rx: 3,
        ry: 3,
        fill: "#000000"
      });
    });
  });

  //turns.forEach(function(turn) {
    //console.log(turn);
  //});
  drawStone(2, 2, "#000000", board);

  $('svg').click(boardClick);
}

function otherColor(color) {
  if(color == "#ffffff"){
    return "#000000";
  }
  return "#ffffff";
}

function drawStone(x, y, color, board) {
      board.append("ellipse")
      .attr({
        cx: x*25+12.5,
        cy: y*25+12.5,
        rx: 9,
        ry: 9,
        fill: otherColor(color)
      });

      board.append("ellipse")
      .attr({
        cx: x*25+12.5,
        cy: y*25+12.5,
        rx: 8,
        ry: 8,
        fill: color
      });
}

function submitTurn(x, y) {
  $('#turn').children('#row').val(y);
  $('#turn').children('#column').val(x);
  $('#turn').submit();
}

function boardClick(e) {
  square = mouseCoordToSquare(e.pageX - $(this).offset().left, e.pageY - $(this).offset().top);
  if(closeToSquare(square[0], square[1]))
    submitTurn(Math.round(square[0]), Math.round(square[1]));
    //console.log(Math.round(square[0]) + ', ' + Math.round(square[1]));
}

function closeToSquare(x, y) {
  if(
      Math.abs(x - Math.round(x)) < 0.25 &&
      Math.abs(y - Math.round(y)) < 0.25
    )
    return true;
  else
    return false;
}

function mouseCoordToSquare(x, y) {
  var squareX = (x - 12.5) / 25; 
  var squareY = (y - 12.5) / 25;

  return [squareX, squareY];
}