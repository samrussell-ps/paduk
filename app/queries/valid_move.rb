class ValidMove
  attr_reader :errors

  def initialize(coordinate, board)
    @coordinate = coordinate
    @board = board
  end

  def call
    Turn.with_table_lock do
      @color = next_color

      @errors = find_errors

      @errors.empty?
    end
  end

  private

  def find_errors
    return [] if pass_turn?

    stone_placement_errors
  end

  def pass_turn?
    @coordinate.nil?
  end

  def stone_placement_errors
    return [:stone_at_coordinate] if stone_at_coordinate?
    return [:violates_ko_rule] if violates_ko_rule?
    return [:violates_suicide_rule] if violates_suicide_rule?

    []
  end

  def stone_at_coordinate?
    @board.stone_at(@coordinate).empty_square? == false
  end

  def violates_ko_rule?
    stones_to_remove.count > 0 && would_retake_last_stone? && replacing_last_stone?
  end

  # TODO comparing array with output of calculation is weird
  # wrap if statement, don't postfix for assignment
  def would_retake_last_stone?
    return false if Turn.last.stone_additions.empty?

    last_move = Turn.last.stone_additions.first.to_coordinate

    stones_to_remove.count == 1 && last_move = stones_to_remove.first
  end

  # TODO comparing array with output of calculation is weird
  def replacing_last_stone?
    return false if Turn.last.stone_removals.empty?

    last_removals = Turn.last.stone_removals.map(&:to_coordinate)

    last_removals == [@coordinate]
  end

  def violates_suicide_rule?
    stones_to_remove.none? &&
      empty_neighbor_squares.none? &&
      same_colored_neighbors.all? { |neighbor_coordinate| would_take_last_liberty?(neighbor_coordinate) }
  end

  def empty_neighbor_squares
    @coordinate.neighbors.select { |neighbor_coordinate| @board.stone_at(neighbor_coordinate).empty_square? }
  end

  def would_take_last_liberty?(neighbor)
    LibertiesCount.new(@board, neighbor).call == 1
  end

  def same_colored_neighbors
    @coordinate.neighbors.select { |neighbor| @board.stone_at(neighbor).color.to_s == @color }
  end

  def next_color
    NextColor.new.call
  end

  # TODO this gets reused, service?
  def stones_to_remove
    surrounded_coordinates.flat_map do |coordinate|
      stone_removals_for_connected_stones(coordinate)
    end.uniq
  end
  
  def stone_removals_for_connected_stones(coordinate)
    ConnectedStones.new(@board, coordinate).call
  end

  def surrounded_coordinates
    # not clear what @coordinate is here
    @coordinate.neighbors.select do |neighbor|
      # TODO really difficult to understand line below
      @board.stone_at(neighbor).color.to_s == OtherColor.new(@color).call &&
        move_will_surround_pieces?(neighbor)
    end
  end

  def move_will_surround_pieces?(coordinate)
    # TODO CalculateLiberties? name needs to match how it's used, not how it does it
    LibertiesCount.new(@board, coordinate).call == 1
  end
end
