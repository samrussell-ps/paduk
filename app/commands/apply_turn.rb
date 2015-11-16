class ApplyTurn
  def initialize(turn)
    @turn = turn
  end

  def call
    @turn.stone_additions.each do |stone_addition|
      Stone.create!(row: stone_addition.row, column: stone_addition.column, color: @turn.color)
    end

    @turn.stone_removals.each do |stone_removal|
      Stone.where(row: stone_removal.row, column: stone_removal.column).each { |stone| stone.destroy! }
    end
  end
end
