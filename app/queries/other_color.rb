class OtherColor
  OTHER_COLOR = {
    'black' => 'white',
    'white' => 'black'
  }

  def initialize(color)
    @color = color
  end

  def call
    OTHER_COLOR[@color]
  end
end
