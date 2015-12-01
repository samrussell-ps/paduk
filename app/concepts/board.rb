class Board
  NUMBER_OF_ROWS = 19
  NUMBER_OF_COLUMNS = 19

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
