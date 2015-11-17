require 'set'

class ConnectedStones
  def initialize(board, coordinate, color)
    @board = board
    @coordinate = coordinate
    @color = color
  end

  def call
    flood_fill(@coordinate, Set.new).to_a
  end

  private

  def flood_fill(coordinate, visited_coordinates)
    if coordinate.valid? && visited_coordinates.exclude?(coordinate) && @board.square(coordinate) == @color
      visited_coordinates << coordinate

      coordinate.neighbors.each do |neighbor|
        visited_coordinates = flood_fill(neighbor, visited_coordinates)
      end
    end

    visited_coordinates 
  end
end
