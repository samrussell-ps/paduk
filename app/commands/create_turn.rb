require 'set'

class CreateTurn
  def initialize(coordinate, board)
    @coordinate = coordinate
    @board = board
  end

  def call
    @color = next_color

    @errors = find_errors

    @errors.empty? && create_turn
  end

  private

  def create_turn
    @turn = Turn.create!(color: @color)

    unless pass_turn?
      create_stone_additions

      create_stone_removals
    end

    true
  end

  def pass_turn?
    @coordinate.nil?
  end

  def create_stone_additions
    @turn.stone_additions.create!(row: @coordinate.row, column: @coordinate.column)
  end

  def create_stone_removals
    stone_removals_for_neighbors.each do |coordinate|
      @turn.stone_removals.create!(row: coordinate.row, column: coordinate.column)
    end
  end

  def stone_removals_for_neighbors
    surrounded_coordinates.flat_map do |coordinate|
      stone_removals_for_connected_stones(coordinate)
    end.uniq
  end
  
  def stone_removals_for_connected_stones(coordinate)
    ConnectedStones.new(@board, coordinate).call
  end

  def surrounded_coordinates
    @coordinate.neighbors.select do |neighbor|
      @board.color_at(neighbor) == OtherColor.new(@color).call &&
        move_will_surround_pieces?(neighbor)
    end
  end

  def move_will_surround_pieces?(coordinate)
    LibertiesCount.new(@board, coordinate).call == 1
  end
  
  def find_errors
    return [] if pass_turn?

    stone_placement_errors
  end

  def stone_placement_errors
    return [:stone_at_coordinate] if stone_at_coordinate?
    return [:ko_rule] if ko_rule?
    return [:suicide_rule] if suicide_rule?

    []
  end

  def stone_at_coordinate?
    @board.color_at(@coordinate).present?
  end

  def ko_rule?
    stone_removals_for_neighbors.count > 0 && taking_last_piece? && replacing_last_piece?
  end

  def taking_last_piece?
    last_move = Turn.last.stone_additions.first.to_coordinate if Turn.last.stone_additions.present?

    [last_move] == stone_removals_for_neighbors.to_a
  end

  def replacing_last_piece?
    last_removals = Turn.last.stone_removals.map(&:to_coordinate) if Turn.last.stone_removals.present?

    last_removals == [@coordinate]
  end

  def suicide_rule?
    stone_removals_for_neighbors.none? &&
      empty_neighbor_squares.none? &&
      same_colored_neighbors.all? { |neighbor| would_take_last_liberty?(neighbor) }
  end

  def empty_neighbor_squares
    @coordinate.neighbors.select { |neighbor| @board.color_at(neighbor) == nil }
  end

  def would_take_last_liberty?(neighbor)
    LibertiesCount.new(@board, neighbor).call == 1
  end

  def same_colored_neighbors
    @coordinate.neighbors.select { |neighbor| @board.color_at(neighbor) == @color }
  end

  def next_color
    NextColor.new.call
  end
end
