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

  describe("#collideStones", function(){
    beforeEach(function(){
      board.display();
    });

    describe("In one dimension", function(){
      it("collides the stones", function(){
        var stone1 = new Stone(4, 4);
        var stone2 = new Stone(4.8, 4);

        board.addStone(stone1);
        board.addStone(stone2);
        stone1.vx = 1.0;

        expect(stone1.vx).toBe(1.0);
        expect(stone1.vy).toBe(0.0);
        expect(stone2.vx).toBe(0.0);
        expect(stone2.vy).toBe(0.0);
        expect(board.elasticity).toBe(0.8);

        board.collideStones(stone1, stone2);

        expect(stone1.vx).toBe(0.0);
        expect(stone1.vy).toBe(0.0);
        expect(stone2.vx).toBe(0.8);
        expect(stone2.vy).toBe(0.0);
      });
    });

    describe("In two dimensions", function(){
      it("collides the stones", function(){
        var stone1 = new Stone(4, 4);
        var stone2 = new Stone(4.4, 4.4);

        board.addStone(stone1);
        board.addStone(stone2);
        stone1.vx = 1.0;
        stone1.vy = 1.0;

        expect(stone1.vx).toBe(1.0);
        expect(stone1.vy).toBe(1.0);
        expect(stone2.vx).toBe(0.0);
        expect(stone2.vy).toBe(0.0);
        expect(board.elasticity).toBe(0.8);

        board.collideStones(stone1, stone2);

        expect(stone1.vx).toBeCloseTo(0.0, 5);
        expect(stone1.vy).toBeCloseTo(0.0, 5);
        expect(stone2.vx).toBeCloseTo(0.8, 5);
        expect(stone2.vy).toBeCloseTo(0.8, 5);
      });
    });

    describe("In two dimensions, non-trivial", function(){
      it("collides the stones", function(){
        var stone1 = new Stone(4, 4);
        var stone2 = new Stone(4.4, 4.4);

        board.addStone(stone1);
        board.addStone(stone2);
        stone1.vx = 1.0;

        expect(stone1.vx).toBe(1.0);
        expect(stone1.vy).toBe(0.0);
        expect(stone2.vx).toBe(0.0);
        expect(stone2.vy).toBe(0.0);
        expect(board.elasticity).toBe(0.8);

        board.collideStones(stone1, stone2);

        expect(stone1.vx).toBeCloseTo(0.5, 5);
        expect(stone1.vy).toBeCloseTo(-0.5, 5);
        expect(stone2.vx).toBeCloseTo(0.4, 5);
        expect(stone2.vy).toBeCloseTo(0.4, 5);
      });
    });
  });
});
