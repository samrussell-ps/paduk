require 'set'

class ConnectedStones
  def initialize(board, coordinate)
    @board = board
    @coordinate = coordinate
    @color = @board.color_at(coordinate)
    @visited_coordinates = Set.new
  end

  def call
    visit_all_coordinates

    @visited_coordinates.to_a
  end

  private

  def visit_all_coordinates
    coordinates_to_visit = []

    coordinates_to_visit << @coordinate

    while next_coordinate = coordinates_to_visit.shift
      visit_coordinate(next_coordinate)

      coordinates_to_visit += neighbors_to_visit(next_coordinate)
    end
  end

  def visit_coordinate(coordinate)
    @visited_coordinates << coordinate
  end

  def neighbors_to_visit(coordinate)
    coordinate.neighbors.select do |neighbor|
      coordinate_needs_to_be_visited?(neighbor)
    end
  end

  def coordinate_needs_to_be_visited?(coordinate)
    coordinate_is_same_color?(coordinate) && coordinate_has_not_been_visited?(coordinate)
  end

  def coordinate_is_same_color?(coordinate)
    @board.color_at(coordinate) == @color
  end

  def coordinate_has_not_been_visited?(coordinate)
    @visited_coordinates.exclude?(coordinate)
  end
end
