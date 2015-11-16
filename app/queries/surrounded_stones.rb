class SurroundedStones
  def call
    Stone.all.map do |stone|
      coordinate = Coordinate.new(row: stone.row, column: stone.column)
      coordinate if LibertiesCount.new(coordinate, stone.color).call == 0
    end.compact
  end
end
