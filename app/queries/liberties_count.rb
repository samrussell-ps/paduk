class LibertiesCount
  def initialize(board, coordinate, color)
    @board = board
    @coordinate = coordinate
    @color = color
  end

  def call
    connected_stones = ConnectedStones.new(@board, @coordinate, @color).call

    liberties_of_group_of_stones(connected_stones)
  end

  def liberties_of_group_of_stones(group_of_stones)
    group_of_stones.reduce(0) do |total_liberties, coordinate|
      total_liberties + liberties_of_single_stone(coordinate)
    end
  end

  def liberties_of_single_stone(coordinate)
    coordinate.neighbors.count do |neighbor|
      empty_square?(neighbor)
    end
  end

  def empty_square?(coordinate)
    coordinate.valid? && @board.square(coordinate).nil?
  end
end
