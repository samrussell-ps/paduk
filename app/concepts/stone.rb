class Stone
  COLORS = [:black, :white]

  attr_reader :color

  def initialize(color:)
    @color = color if COLORS.include?(color)
  end
end
