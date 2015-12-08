describe("BoardSpec", function() {
  var board, flushAllD3Transitions;

  beforeEach(function() {
    setFixtures('<div id="board-container"></div>');

     flushAllD3Transitions = function() {
      var now = Date.now;
      Date.now = function() { return Infinity; };
      d3.timer.flush();
      Date.now = now;
    };

    board = new Board();
  });

  it("creates a 475x475 board", function(){
    expect(board.width).toBe(475);
    expect(board.height).toBe(475);
  });

  describe("#display()", function(){
    it("creates an svg with correct width and height", function() {
      expect($("#board-container").children("svg").length).toBe(0);

      board.display();

      var svg = $("#board-container").children("svg");

      expect(svg.length).toBe(1);

      expect(svg.attr("width")).toBe("475px");
      expect(svg.attr("height")).toBe("475px");
    });
  });

  describe("#addLine", function(){
    beforeEach(function(){
      board.display();
    });

    it("adds a line", function(){
      var linesOnBoard = function() {
        return board.canvas.selectAll("g.line")[0].length;
      }

      expect(linesOnBoard()).toBe(38);

      var line = new Line(0, 0, 10, "horizontal");
      board.addLine(line);
      board.displayLines();

      expect(linesOnBoard()).toBe(39);
    });
  });

  describe("#addStone", function(){
    beforeEach(function(){
      board.display();
    });

    it("adds a stone", function(){
      var stonesOnBoard = function() {
        return board.canvas.selectAll("g.stone")[0].length;
      }

      expect(stonesOnBoard()).toBe(0);

      var stone = new Stone(10, 10, new Color("white"));
      board.addStone(stone);
      board.displayStones();

      expect(stonesOnBoard()).toBe(1);
    });
  });

  describe("#updateStones", function(){
    beforeEach(function(){
      board.display();
    });

    it("moves a stone", function(){
      var stonesOnBoard = function() {
        return board.canvas.selectAll("g.stone")[0].length;
      }

      var stoneOnBoard = function(index){
        return d3.select(board.canvas.selectAll("g.stone")[0][index]);
      };

      expect(stonesOnBoard()).toBe(0);
      
      var initialX = 10;
      var initialY = 15;

      var secondX = 20;
      var secondY = 25;

      var boardToCanvas = function(board_offset){
        return board_offset*25 + 12.5;
      };

      var stone = new Stone(initialX, initialY, new Color("white"));
      board.addStone(stone);
      board.displayStones();

      expect(stonesOnBoard()).toBe(1);
      expect(stoneOnBoard(0).attr("transform")).toBe("translate(" + boardToCanvas(initialX) + "," + boardToCanvas(initialY) + ")");

      stone.setCoord(secondX, secondY); 
      board.updateStones();
      flushAllD3Transitions();

      expect(stoneOnBoard(0).attr("transform")).toBe("translate(" + boardToCanvas(secondX) + "," + boardToCanvas(secondY) + ")");
    });
  });
});

describe("calculateGroundCollision", function() {
  describe("stone is still, not on ground", function() {
    xit("does nothing to vy", function() {
      stoneData = {cx: 5, cy: 5, rx: 5, ry: 5, vx: 0, vy: 0, fill: '#000000'};

      calculateGroundCollision(stoneData);

      expect(stoneData.vy).toBe(0);
    });
  });

  describe("stone is still, colliding with ground", function() {
    xit("does nothing to vy", function() {
      stoneData = {cx: 5, cy: 475, rx: 5, ry: 5, vx: 0, vy: 0, fill: '#000000'};

      calculateGroundCollision(stoneData);

      expect(stoneData.vy).toBe(0);
    });
  });

  describe("stone is moving below threshold, colliding with ground", function() {
    xit("sets vy to 0", function() {
      stoneData = {cx: 5, cy: 475, rx: 5, ry: 5, vx: 0, vy: 0.8, fill: '#000000'};

      calculateGroundCollision(stoneData);

      expect(stoneData.vy).toBe(0);
    });
  });

  describe("stone is moving above threshold, colliding with ground", function() {
    xit("sets vy to -elasticity", function() {
      stoneData = {cx: 5, cy: 475, rx: 5, ry: 5, vx: 0, vy: 3, fill: '#000000'};

      calculateGroundCollision(stoneData);

      expect(stoneData.vy).toBe(-2.7);
    });
  });
});
