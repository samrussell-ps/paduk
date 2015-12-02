class VulnerableNeighbors
  def initialize(board, coordinate, color)
    @board = board
    @coordinate = coordinate
    @color = color
  end

  def call
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
        move_will_fill_last_free_square?(neighbor)
    end
  end

  def move_will_fill_last_free_square?(coordinate)
    # TODO CalculateLiberties? name needs to match how it's used, not how it does it
    LibertiesCount.new(@board, coordinate).call == 1
  end
end
