require 'set'

class ConnectedStones
  def initialize(row, column)
    @row = row
    @column = column
  end

  def call
    flood_fill([@row, @column], Set.new).to_a
  end

  private

  def flood_fill(coordinate, visited_coordinates)
    if coordinate_is_valid?(coordinate) && visited_coordinates.exclude?(coordinate) && Stone.where(row: coordinate[0], column: coordinate[1]).present?
      visited_coordinates << coordinate

      [:north, :east, :south, :west].each do |direction|
        visited_coordinates = flood_fill(move(direction, coordinate), visited_coordinates)
      end
    end

    visited_coordinates 
  end

  def coordinate_is_valid?(coordinate)
    coordinate && (0...Stone::NUMBER_OF_ROWS).include?(coordinate[0]) && (0...Stone::NUMBER_OF_COLUMNS).include?(coordinate[1])
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
