def locations_to_coordinates(locations)
  coordinates = Set.new

  locations.each_with_index do |row, row_number|
    row.each_with_index do |cell, column_number|
      if cell > 0
        coordinates.add(Coordinate.new(row: row_number, column: column_number))
      end
    end
  end

  coordinates
end

def init_board(stone_locations)
  colors = %w(none black white)

  locations_to_coordinates(stone_locations).each do |coordinate|
    color = colors[stone_locations[coordinate.row][coordinate.column]]
    board.place(coordinate, Stone.new(color: color))
  end
end
