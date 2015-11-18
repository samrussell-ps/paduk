class ApplyTurn
  def initialize(turn, board)
    @turn = turn
    @board = board
  end

  def call
    apply_stone_additions

    apply_stone_removals

    true
  end

  def apply_stone_additions
    @turn.stone_additions.each do |stone_addition|
      @board.place(stone_move_to_coordinate(stone_addition), @turn.color)
    end
  end

  def apply_stone_removals
    @turn.stone_removals.each do |stone_removal|
      @board.remove(stone_move_to_coordinate(stone_removal))
    end
  end

  private
  
  def stone_move_to_coordinate(stone_move)
    Coordinate.new(row: stone_move.row, column: stone_move.column)
  end
end
