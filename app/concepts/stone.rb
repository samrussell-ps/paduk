class Stone
  COLORS = [:black, :white]

  attr_reader :color

  def initialize(color: nil)
    @color = color if COLORS.include?(color)
  end

  def empty_square?
    @color == nil
  end
end
