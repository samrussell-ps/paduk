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
    @color = next_color

    find_errors

    @errors.empty? && create_turn
  end

  private

  def create_turn
    @turn = Turn.create!(color: @color)

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
    ConnectedStones.new(@board, coordinate).call
  end

  def surrounded_coordinates
    @coordinate.neighbors.select do |neighbor|
      @board.square(neighbor) == OTHER_COLOR[@color] &&
        move_will_surround_pieces?(neighbor)
    end
  end

  def move_will_surround_pieces?(coordinate)
    LibertiesCount.new(@board, coordinate).call == 1
  end

  def find_errors
    @errors = []

    if @coordinate
      @errors += stone_placement_errors
    end
  end

  def stone_placement_errors
    if stone_at_coordinate?
      [:stone_at_coordinate]
    else
      taking_stones_errors
    end
  end

  def taking_stones_errors
    if stone_removals_for_neighbors.count > 0
      ko_rule_errors
    else
      square_liberties_errors
    end
  end

  def ko_rule_errors
    if ko_rule?
      [:ko_rule]
    else
      []
    end
  end

  def square_liberties_errors
    if suicide_rule?
      [:suicide_rule]
    else
      []
    end
  end

  def ko_rule?
    taking_last_piece? && replacing_last_piece?
  end

  def suicide_rule?
    empty_neighbor_squares.count == 0 &&
      same_colored_neighbors.all? do |neighbor|
        would_take_last_liberty(neighbor)
      end
  end

  def empty_neighbor_squares
    @coordinate.neighbors.select { |neighbor| @board.square(neighbor) == nil }
  end

  def would_take_last_liberty(neighbor)
    LibertiesCount.new(@board, neighbor).call == 1
  end

  def same_colored_neighbors
    @coordinate.neighbors.select { |neighbor| @board.square(neighbor) == @color }
  end

  def taking_last_piece?
    last_move = Turn.last.stone_additions.first.to_coordinate if Turn.last.stone_additions.present?

    [last_move] == stone_removals_for_neighbors.to_a
  end

  def replacing_last_piece?
    last_removals = Turn.last.stone_removals.map(&:to_coordinate) if Turn.last.stone_removals.present?

    last_removals == [@coordinate]
  end

  def stone_at_coordinate?
    @board.square(@coordinate).present?
  end

  def next_color
    NextColor.new.call
  end
end
