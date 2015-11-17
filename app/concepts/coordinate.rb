class Coordinate
  attr_reader :row
  attr_reader :column

  def initialize(**args)
    @row = args[:row]
    @column = args[:column]
  end

  def neighbors
    [ Coordinate.new(row: @row + 1, column: @column),
      Coordinate.new(row: @row - 1, column: @column),
      Coordinate.new(row: @row, column: @column + 1),
      Coordinate.new(row: @row, column: @column - 1)
    ].each_with_object([]) do |neighbor, array|
      array << neighbor if neighbor.valid?
    end
  end

  def valid?
    (0...Board::NUMBER_OF_ROWS).include?(@row) && (0...Board::NUMBER_OF_COLUMNS).include?(@column)
  end

  def hash
    [@row, @column].hash
  end

  def ==(other)
    @row == other.row && @column == other.column
  end

  def eql?(other)
    self == other
  end
end
