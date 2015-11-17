class ApplyTurn
  def initialize(turn, board)
    @turn = turn
    @board = board
  end

  def call
    @turn.stone_additions.each do |stone_addition|
      #Stone.create!(row: stone_addition.row, column: stone_addition.column, color: @turn.color)
      @board.place(Coordinate.new(row: stone_addition.row, column: stone_addition.column), @turn.color)
    end

    @turn.stone_removals.each do |stone_removal|
      @board.remove(Coordinate.new(row: stone_removal.row, column: stone_removal.column))
    end
  end
end
