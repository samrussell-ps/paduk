class LibertiesCount
  def initialize(board, coordinate, color)
    @board = board
    @coordinate = coordinate
    @color = color
  end

  def call
    connected_stones = ConnectedStones.new(@board, @coordinate, @color).call
    connected_stones.reduce(0) do |liberties, coordinate|
      liberties + coordinate.neighbors.count do |neighbor|
        neighbor.valid? && @board.square(neighbor).nil?
      end
    end
  end
end
