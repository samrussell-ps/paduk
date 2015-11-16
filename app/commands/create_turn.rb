class CreateTurn
  OTHER_COLOR = {
    'black' => 'white',
    'white' => 'black'
  }

  def initialize(coordinate)
    @coordinate = coordinate
  end

  def call
    find_errors

    if @errors.empty?
      turn = Turn.create!(color: next_color)

      turn.stone_additions.create!(row: @coordinate.row, column: @coordinate.column) if @coordinate

      if @coordinate
        surrounded_coordinates.each do |coordinate|
          turn.stone_removals.create!(row: coordinate.row, column: coordinate.column)
        end
      end
    end

    @errors.empty?
  end

  private

  def surrounded_coordinates
    @coordinate.neighbors.select do |neighbor|
      stones = Stone.where(row: neighbor.row, column: neighbor.column)
      LibertiesCount.new(neighbor, stones.first.color).call == 1 if stones.present?
    end
  end

  def find_errors
    @errors = []

    if @coordinate
      @errors << :stone_at_coordinate if stone_at_coordinate?
    end
  end

  def stone_at_coordinate?
    Stone.where(row: @coordinate.row, column: @coordinate.column).present?
  end

  def next_color
    if Turn.last
      OTHER_COLOR[Turn.last.color]
    else
      'black'
    end
  end
end
