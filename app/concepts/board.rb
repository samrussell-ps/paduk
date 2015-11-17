class Board
  NUMBER_OF_ROWS = 19
  NUMBER_OF_COLUMNS = 19

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
end
