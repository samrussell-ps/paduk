class NextColor
  OTHER_COLOR = {
    'black' => 'white',
    'white' => 'black'
  }

  def call
    return 'black' if Turn.count == 0

    OTHER_COLOR[Turn.last.color]
  end
end
