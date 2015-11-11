class SurroundedStones
  def call
    Stone.all.map do |stone|
      connected_stones = ConnectedStones.new(stone.row, stone.column, stone.color).call
      if connected_stones.all? { |coordinate| surrounded?(coordinate) }
        [stone.row, stone.column]
      end
    end.compact
  end

  private

  def surrounded?(coordinate)
    [:north, :east, :south, :west].all? do |direction|
      test_coordinate = move(direction, coordinate)
      stone_at_coordinate = Stone.where(row: test_coordinate[0], column: test_coordinate[1]).first
      !coordinate_is_valid?(test_coordinate) || (stone_at_coordinate.present?)
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
