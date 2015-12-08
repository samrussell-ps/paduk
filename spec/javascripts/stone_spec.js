describe("StoneSpec", function() {
  describe("#velocityMagnitude()", function(){
    it("calculates velocity magnitude correctly, one dimension", function(){
      var stone = new Stone(0, 0);
      stone.vx = 1.0;
      stone.vy = 0.0;

      expect(stone.velocityMagnitude()).toBeCloseTo(1.0, 5);
    });

    it("calculates velocity magnitude correctly, two dimensions", function(){
      var stone = new Stone(0, 0);
      stone.vx = 1.0;
      stone.vy = 1.0;

      expect(stone.velocityMagnitude()).toBeCloseTo(1.4142, 3);
    });

    it("calculates velocity magnitude correctly, two dimensions, non-unit", function(){
      var stone = new Stone(0, 0);
      stone.vx = 3.2;
      stone.vy = -0.1;

      expect(stone.velocityMagnitude()).toBeCloseTo(3.2015, 3);
    });
  });
});
