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

  def stone_at(coordinate)
    @stones[coordinate] || empty_square
  end

  def place(coordinate, stone)
    @stones[coordinate] = stone
  end

  def remove(coordinate)
    @removed_stones[stone_at(coordinate).color] += 1

    @stones[coordinate] = empty_square
  end

  def as_json
    black_stones = @stones.map do |coordinate, stone|
      coordinate.as_json if stone.color == 'black'
    end.compact

    white_stones = @stones.map do |coordinate, stone|
      coordinate.as_json if stone.color == 'white'
    end.compact

    data = { 'removed_stones' => @removed_stones,
      'stones' => {
        'black' => black_stones,
        'white' => white_stones
      }
    }
  end

  private

  def empty_square
    Stone.new(color: nil)
  end
end
