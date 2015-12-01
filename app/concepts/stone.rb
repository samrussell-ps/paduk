class Stone
  COLORS = ['black', 'white']

  attr_reader :color

  def initialize(color: nil)
    @color = color if COLORS.include?(color)
  end

  def empty_square?
    @color == nil
  end

  def hash
    [@color].hash
  end

  def ==(other)
    @color == other.color
  end

  def eql?(other)
    self == other
  end
end
