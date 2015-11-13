class CreateTurn
  OTHER_COLOR = {
    'black' => 'white',
    'white' => 'black'
  }

  def initialize(coordinate)
    @coordinate = coordinate
  end

  def call
    turn = Turn.create!(color: next_color)

    turn.stone_additions.create!(row: @coordinate.row, column: @coordinate.column) if @coordinate

    turn.valid?
  end

  private

  def next_color
    if Turn.last
      OTHER_COLOR[Turn.last.color]
    else
      'black'
    end
  end
end
