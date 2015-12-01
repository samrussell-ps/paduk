describe("ColorSpec", function() {
  describe("#to_s", function() {
    it("returns the string version", function() {
      var whiteColor = new Color("white");
      var blackColor = new Color("black");
      var badColor = new Color("green");
      
      expect(whiteColor.to_s()).toBe("#ffffff");
      expect(blackColor.to_s()).toBe("#000000");
      expect(badColor.to_s()).toBe(null);
    });
  });

  describe("#other", function() {
    it("returns the other color", function() {
      var whiteColor = new Color("white");
      var blackColor = new Color("black");
      var badColor = new Color("green");
      
      expect(whiteColor.other().to_s()).toBe("#000000");
      expect(blackColor.other().to_s()).toBe("#ffffff");
      expect(badColor.other().to_s()).toBe(null);

      expect(whiteColor.other().other().to_s()).toBe("#ffffff");
      expect(blackColor.other().other().to_s()).toBe("#000000");
    });
  });
});

describe("BoardSpec", function () {
  var board;
  beforeEach(function() {
    setFixtures('<div id="board-container"></div>');
    var board_data = {"removed_stones":{"black":0,"white":0},"stones":{"black":[{"row":3,"column":15},{"row":3,"column":3}],"white":[{"row":15,"column":3},{"row":15,"column":16}]}};
    board = new Board();
  });

  describe("#display()", function() {
    beforeEach(function() {
      board.display();
    });

    it("creates an svg", function() {
      expect($("#board-container").children()).toContain("svg");
    });

    it("creates the back of the board", function() {
      expect($("#board-container").children("svg").children("rect").length).toBe(1);
      expect($("#board-container").children("svg").children("rect").attr("fill")).toBe("#E09E48");
    });

    it("draws the lines", function() {
      expect($("#board-container").children("svg").children("line").length).toBe(19*2);
    });
  });

  describe("#placeStone()", function() {
    beforeEach(function() {
      board.display();
    });

    it("adds a stone", function() {
      var coordinate = { "row" : 4, "column" : 2 };
      var color = new Color('white');

      expect($("#board-container").children("svg").children("ellipse").length).toBe(9);

      board.placeStone(coordinate, color);

      expect($("#board-container").children("svg").children("ellipse").length).toBe(9 + 2);
    });
  });

  describe("#mouseCoordToSquare", function() {
    it("converts click coords to square coords", function() {
      expect(board.mouseCoordToSquare(112.5, 212.5)[0]).toBe(4);
      expect(board.mouseCoordToSquare(112.5, 212.5)[1]).toBe(8);
    });
  });

  describe("#closeToSquare", function() {
    it("correctly decides when a coords are close to a square", function() {
      expect(board.closeToSquare(4, 5)).toBe(true);
      expect(board.closeToSquare(4.2, 5)).toBe(true);
      expect(board.closeToSquare(3.8, 5)).toBe(true);
      expect(board.closeToSquare(5, 3.8)).toBe(true);
      expect(board.closeToSquare(5, 4.2)).toBe(true);
      expect(board.closeToSquare(4.3, 5)).toBe(false);
      expect(board.closeToSquare(3.7, 5)).toBe(false);
      expect(board.closeToSquare(5, 3.7)).toBe(false);
      expect(board.closeToSquare(5, 4.3)).toBe(false);
    });
  });
});
