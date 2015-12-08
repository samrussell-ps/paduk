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
