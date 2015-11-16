class LibertiesCount
  def initialize(coordinate, color)
    @coordinate = coordinate
    @color = color
  end

  def call
    connected_stones = ConnectedStones.new(@coordinate, @color).call
    connected_stones.reduce(0) do |liberties, coordinate|
      liberties + coordinate.neighbors.count do |neighbor|
        neighbor.valid? && Stone.where(row: neighbor.row, column: neighbor.column).empty?
      end
    end
  end
end
