class RemoveSurroundedStones
  def initialize(color)
    @color = color
  end

  def call
    SurroundedStones.new.call.each do |coordinate|
      stone_to_remove = Stone.where(row: coordinate[0], column: coordinate[1]).first

      stone_to_remove.destroy! if stone_to_remove.color == @color
    end
  end
end
