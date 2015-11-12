class SurroundedStones
  def call
    Stone.all.map do |stone|
      coordinate = Coordinate.new(row: stone.row, column: stone.column)
      connected_stones = ConnectedStones.new(coordinate, stone.color).call
      if connected_stones.all? { |test_coordinate| surrounded?(test_coordinate) }
        coordinate
      end
    end.compact
  end

  private

  def surrounded?(coordinate)
    coordinate.neighbors.all? do |neighbor|
      stone_at_coordinate = Stone.where(row: neighbor.row, column: neighbor.column).first
      stone_at_coordinate.present?
    end
  end
end
