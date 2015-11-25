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
      @board.place(stone_addition.to_coordinate, @turn.color)
    end
  end

  def apply_stone_removals
    @turn.stone_removals.each do |stone_removal|
      @board.remove(stone_removal.to_coordinate)
    end
  end
end
