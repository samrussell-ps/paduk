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

    @errors.empty? && create_turn
  end

  private

  def create_turn
    @turn = Turn.create!(color: next_color)

    if @coordinate
      create_stone_additions

      create_stone_removals
    end

    true
  end

  def create_stone_additions
    @turn.stone_additions.create!(row: @coordinate.row, column: @coordinate.column) if @coordinate
  end

  def create_stone_removals
    surrounded_coordinates.each do |coordinate|
      @turn.stone_removals.create!(row: coordinate.row, column: coordinate.column)
    end
  end


  def surrounded_coordinates
    @coordinate.neighbors.select do |neighbor|
      move_will_surround_pieces?(neighbor)
    end
  end

  def move_will_surround_pieces?(coordinate)
    color = @board.square(coordinate)

    color && (LibertiesCount.new(@board, coordinate, color).call == 1)
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
    NextColor.new.call
  end
end
