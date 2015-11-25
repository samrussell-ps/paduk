require 'set'

class LibertiesCount
  def initialize(board, coordinate)
    @board = board
    @coordinate = coordinate
    @color = @board.color_at(coordinate)
  end

  def call
    connected_stones = ConnectedStones.new(@board, @coordinate).call

    liberties_of_group_of_stones(connected_stones).count
  end

  def liberties_of_group_of_stones(group_of_stones)
    group_of_stones.reduce([]) do |total_liberties, coordinate|
      total_liberties + liberties_of_single_stone(coordinate)
    end.uniq
  end

  def liberties_of_single_stone(coordinate)
    coordinate.neighbors.select do |neighbor|
      empty_square?(neighbor)
    end
  end

  def empty_square?(coordinate)
    @board.color_at(coordinate).nil?
  end
end
