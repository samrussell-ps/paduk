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

  def square(coordinate)
    @squares[coordinate]
  end

  def place(coordinate, color)
    @squares[coordinate] = color
  end

  def remove(coordinate)
    @squares[coordinate] = nil
  end

  def to_s
    (0...NUMBER_OF_ROWS).reduce('') do |output, row|
      (0...NUMBER_OF_COLUMNS).reduce(output) do |output, column|
        coordinate = Coordinate.new(row: row, column: column)

        output + COLOR_TO_TEXT_SYMBOL[square(coordinate)]
      end + "\n"
    end
  end
end
