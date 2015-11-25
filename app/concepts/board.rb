class Board
  NUMBER_OF_ROWS = 19
  NUMBER_OF_COLUMNS = 19
  COLOR_TO_TEXT_SYMBOL = {
    'white' => 'o',
    'black' => 'x',
    nil => '.'
  }

  def initialize
    @squares = {}
    @last_move = nil
  end

  def color_at(coordinate)
    @squares[coordinate]
  end

  def place(coordinate, color)
    @squares[coordinate] = color
  end

  def remove(coordinate)
    @squares[coordinate] = nil
  end

  def to_s
    (0...NUMBER_OF_ROWS).map do |row|
      (0...NUMBER_OF_COLUMNS).map do |column|
        coordinate = Coordinate.new(row: row, column: column)

        COLOR_TO_TEXT_SYMBOL[color_at(coordinate)]
      end.join
    end.join("\n")
  end
end
