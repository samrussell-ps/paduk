class VulnerableNeighbors
  def initialize(board, coordinate, color)
    @board = board
    @coordinate = coordinate
    @color = color
  end

  def call
    vulnerable_immediate_neighbors.flat_map do |vulnerable_immediate_neighbor|
      stones_connected_to_vulnerable_immediate_neighbor(vulnerable_immediate_neighbor)
    end.uniq
  end

  private
  
  def stones_connected_to_vulnerable_immediate_neighbor(vulnerable_immediate_neighbor)
    ConnectedStones.new(@board, vulnerable_immediate_neighbor).call
  end

  def vulnerable_immediate_neighbors
    @coordinate.neighbors.select do |neighbor|
      opponents_stone?(neighbor) && move_will_fill_last_free_square?(neighbor)
    end
  end

  def opponents_stone?(neighbor)
    @board.stone_at(neighbor).color == opponents_color
  end

  def opponents_color
    OtherColor.new(@color).call
  end

  def move_will_fill_last_free_square?(neighbor)
    LibertiesCount.new(@board, neighbor).call == 1
  end
end
