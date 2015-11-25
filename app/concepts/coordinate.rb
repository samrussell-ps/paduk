class Coordinate
  attr_reader :row
  attr_reader :column

  def initialize(row:, column:)
    @row = row
    @column = column
  end

  def neighbors
    possible_neighbors.select(&:valid?)
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

  private

  def possible_neighbors
    [
      Coordinate.new(row: @row + 1, column: @column),
      Coordinate.new(row: @row - 1, column: @column),
      Coordinate.new(row: @row, column: @column + 1),
      Coordinate.new(row: @row, column: @column - 1),
    ]
  end
end
