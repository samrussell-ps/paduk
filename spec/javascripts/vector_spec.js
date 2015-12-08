describe("Vector", function(){
  describe("#magnitude()", function(){
    it("calculates magnitude correctly, one dimension", function(){
      var vector = new Vector(1.0, 0);

      expect(vector.magnitude()).toBeCloseTo(1.0, 5);
    });

    it("calculates magnitude correctly, two dimensions", function(){
      var vector = new Vector(1.0, 1.0);

      expect(vector.magnitude()).toBeCloseTo(1.4142, 3);
    });

    it("calculates magnitude correctly, two dimensions, non-unit", function(){
      var vector = new Vector(3.2, -0.1);

      expect(vector.magnitude()).toBeCloseTo(3.2015, 3);
    });
  });

  describe("#toUnitVector()", function(){
    it("works correctly, one dimension", function(){
      var vector = new Vector(3.0, 0);
      var unitVector = vector.toUnitVector();

      expect(unitVector.x).toBeCloseTo(1.0, 5);
      expect(unitVector.y).toBeCloseTo(0.0, 5);
    });

    it("works correctly, two dimensions", function(){
      var vector = new Vector(3.0, -1.3);
      var unitVector = vector.toUnitVector();

      expect(unitVector.x).toBeCloseTo(0.9175, 3);
      expect(unitVector.y).toBeCloseTo(-0.3976, 3);
    });
  });

  describe("#toUnitVector()", function(){
    it("works correctly, perfect overlap", function(){
      var vector1 = new Vector(1.0, 0);
      var vector2 = new Vector(1.0, 0);

      expect(vector1.dotProduct(vector2)).toBeCloseTo(1.0, 3);
    });

    it("works correctly, perfect negative overlap", function(){
      var vector1 = new Vector(1.0, 0);
      var vector2 = new Vector(-1.0, 0);

      expect(vector1.dotProduct(vector2)).toBeCloseTo(-1.0, 3);
    });

    it("works correctly, 0 overlap", function(){
      var vector1 = new Vector(1.0, 0);
      var vector2 = new Vector(0, 1.0);

      expect(vector1.dotProduct(vector2)).toBeCloseTo(0.0, 3);
    });

    it("works correctly, 45 degrees", function(){
      var vector1 = new Vector(2.0, 0);
      var vector2 = new Vector(1.0, 1.0);

      expect(vector1.dotProduct(vector2)).toBeCloseTo(2.0, 3);
    });

    it("works correctly, 45 degrees, unit vectors", function(){
      var vector1 = new Vector(2.0, 0).toUnitVector();
      var vector2 = new Vector(1.0, 1.0).toUnitVector();

      expect(vector1.dotProduct(vector2)).toBeCloseTo(0.7071, 3);
    });
  });
});
