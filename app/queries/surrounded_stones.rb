class SurroundedStones
  def call
    Stone.all.map do |stone|
      if surrounded?(stone)
        [stone.row, stone.column]
      end
    end.compact
  end

  private

  def surrounded?(stone)
    [:north, :east, :south, :west].all? do |direction|
      coordinate = move(direction, [stone.row, stone.column])
      stone_at_coordinate = Stone.where(row: coordinate[0], column: coordinate[1]).first
      !coordinate_is_valid?(coordinate) || (stone_at_coordinate.present? && stone_at_coordinate.color != stone.color)
    end
  end

  def coordinate_is_valid?(coordinate)
    (0...Stone::NUMBER_OF_ROWS).include?(coordinate[0]) && (0...Stone::NUMBER_OF_COLUMNS).include?(coordinate[1])
  end

  def move(direction, coordinate)
    case direction
    when :north
      [coordinate[0]-1, coordinate[1]]
    when :south
      [coordinate[0]+1, coordinate[1]]
    when :east
      [coordinate[0], coordinate[1]-1]
    when :west
      [coordinate[0], coordinate[1]+1]
    end
  end
end
