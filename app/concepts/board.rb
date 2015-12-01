class Board
  NUMBER_OF_ROWS = 19
  NUMBER_OF_COLUMNS = 19
  # TODO make decorator, text printing is not core to this class
  # debugging stuff can be in other debuggy places
  COLOR_TO_TEXT_SYMBOL = {
    'white' => 'o',
    'black' => 'x',
    nil => '.'
  }

  attr_reader :removed_stones

  def initialize
    @stones = {}
    @last_move = nil
    @removed_stones = {
      'black' => 0,
      'white' => 0
    }
  end

  def color_at(coordinate)
    @stones[coordinate]
  end

  def place(coordinate, color)
    @stones[coordinate] = color
  end

  def remove(coordinate)
    @removed_stones[color_at(coordinate)] += 1

    @stones[coordinate] = nil
  end

  def to_s
    (0...NUMBER_OF_ROWS).map do |row|
      (0...NUMBER_OF_COLUMNS).map do |column|
        coordinate = Coordinate.new(row: row, column: column)

        COLOR_TO_TEXT_SYMBOL[color_at(coordinate)]
      end.join
    end.join("\n")
  end

  def as_json
    black_stones = @stones.map do |coordinate, color|
      coordinate.as_json if color == 'black'
    end.compact

    white_stones = @stones.map do |coordinate, color|
      coordinate.as_json if color == 'white'
    end.compact

    data = { 'removed_stones' => @removed_stones,
      'stones' => {
        'black' => black_stones,
        'white' => white_stones
      }
    }
  end
end
