class NextColor
  def call
    return 'black' if Turn.count == 0

    OtherColor.new(Turn.last.color).call
  end
end
