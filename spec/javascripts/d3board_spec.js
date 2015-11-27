describe("D3BoardSpec", function () {

  beforeEach(function() {
    setFixtures('<div id="board-container"></div>');
    initBoard();
  });

  it("creates an svg", function() {
    expect($("#board-container").children()).toContain("svg");
  });

  it("creates the back of the board", function() {
    expect($('#board-container').children('svg').children(('rect')).length).toBe(1)
    expect($('#board-container').children('svg').children(('rect')).attr('fill')).toBe('#E09E48')
  });

  it("draws the lines", function() {
    expect($('#board-container').children('svg').children(('line')).length).toBe(19*2)
  });
});
