require 'set'

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

    if !@coordinate
      true
    else
      create_stone_additions

      create_stone_removals

      true
    end
  end

  def create_stone_additions
    @turn.stone_additions.create!(row: @coordinate.row, column: @coordinate.column) if @coordinate
  end

  def create_stone_removals
    stone_removals_for_neighbors.each do |coordinate|
      @turn.stone_removals.create!(row: coordinate.row, column: coordinate.column)
    end
  end

  def stone_removals_for_neighbors
    surrounded_coordinates.reduce(Set.new) do |coordinates_to_remove, coordinate|
      coordinates_to_remove + stone_removals_for_connected_stones(coordinate)
    end
  end
  
  def stone_removals_for_connected_stones(coordinate)
    ConnectedStones.new(@board, coordinate, @board.square(coordinate)).call
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
      @errors << :ko_rule if ko_rule?
    end
  end

  def ko_rule?
    taking_last_piece? && replacing_last_piece?
  end

  def taking_last_piece?
    last_move = turn_to_coordinate(Turn.last.stone_additions.first) if Turn.last

    [last_move] == stone_removals_for_neighbors.to_a
  end

  def replacing_last_piece?
    last_removals = Turn.last.stone_removals.map { |stone_removal| turn_to_coordinate(stone_removal) } if Turn.last

    last_removals == [@coordinate]
  end

  def stone_at_coordinate?
    @board.square(@coordinate).present?
  end

  def next_color
    NextColor.new.call
  end

  # TODO make Coordinate instantiate from Turn
  def turn_to_coordinate(turn)
    Coordinate.new(row: turn.row, column: turn.column) if turn
  end
end
