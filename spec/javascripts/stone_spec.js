describe("calculateGroundCollision", function() {
  describe("stone is still, not on ground", function() {
    it("does nothing to vy", function() {
      stoneData = {cx: 5, cy: 5, rx: 5, ry: 5, vx: 0, vy: 0, fill: '#000000'};

      calculateGroundCollision(stoneData);

      expect(stoneData.vy).toBe(0);
    });
  });

  describe("stone is still, colliding with ground", function() {
    it("does nothing to vy", function() {
      stoneData = {cx: 5, cy: 475, rx: 5, ry: 5, vx: 0, vy: 0, fill: '#000000'};

      calculateGroundCollision(stoneData);

      expect(stoneData.vy).toBe(0);
    });
  });

  describe("stone is moving below threshold, colliding with ground", function() {
    it("sets vy to 0", function() {
      stoneData = {cx: 5, cy: 475, rx: 5, ry: 5, vx: 0, vy: 0.8, fill: '#000000'};

      calculateGroundCollision(stoneData);

      expect(stoneData.vy).toBe(0);
    });
  });

  describe("stone is moving above threshold, colliding with ground", function() {
    it("sets vy to -elasticity", function() {
      stoneData = {cx: 5, cy: 475, rx: 5, ry: 5, vx: 0, vy: 1, fill: '#000000'};

      calculateGroundCollision(stoneData);

      expect(stoneData.vy).toBe(0 - elasticity);
    });
  });
});
