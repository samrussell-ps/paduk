class CreateTurn
  OTHER_COLOR = {
    'black' => 'white',
    'white' => 'black'
  }

  def initialize(coordinate, board)
    @coordinate = coordinate
    @board = board
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
      color = @board.square(neighbor)
      color && LibertiesCount.new(@board, neighbor, color).call == 1
    end
  end

  def find_errors
    @errors = []

    if @coordinate
      @errors << :stone_at_coordinate if stone_at_coordinate?
    end
  end

  def stone_at_coordinate?
    @board.square(@coordinate).present?
  end

  def next_color
    if Turn.last
      OTHER_COLOR[Turn.last.color]
    else
      'black'
    end
  end
end
