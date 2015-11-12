require 'rails_helper'

describe SurroundedStones do
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

  let(:stone_locations) { 
    [
      [ 2, 1, 1, 1, 1, 0, 1 ],
      [ 1, 0, 1, 2, 1, 0, 1 ],
      [ 1, 0, 1, 1, 1, 0, 1 ],
      [ 2, 1, 1, 1, 1, 1, 1 ],
      [ 1, 0, 1, 2, 1, 0, 1 ],
      [ 1, 0, 1, 2, 1, 0, 1 ],
      [ 1, 1, 1, 1, 1, 0, 1 ],
    ]
  }

  let(:not_surrounded_locations) { 
    [
      [ 0, 1, 1, 1, 1, 1, 1 ],
      [ 1, 1, 1, 0, 1, 1, 1 ],
      [ 1, 1, 1, 1, 1, 1, 1 ],
      [ 0, 1, 1, 1, 1, 1, 1 ],
      [ 1, 1, 1, 0, 1, 1, 1 ],
      [ 1, 1, 1, 0, 1, 1, 1 ],
      [ 1, 1, 1, 1, 1, 1, 1 ],
    ]
  }

  let(:trivial_surrounded_locations) { 
    [
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 2, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
    ]
  }

  let(:edge_and_corner_locations) { 
    [
      [ 2, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 2, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
    ]
  }

  let(:connected_locations) { 
    [
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 2, 0, 0, 0 ],
      [ 0, 0, 0, 2, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
    ]
  }

  subject(:surrounded_stones) { SurroundedStones.new.call }

  before do
    colors = %w(none black white)

    locations_to_coordinates(stone_locations).each do |coordinate|
      color = colors[stone_locations[coordinate.row][coordinate.column]]
      Stone.create!(row: coordinate.row, column: coordinate.column, color: color)
    end
  end

  it 'only finds surrounded stones' do
    not_surrounded_coordinates = locations_to_coordinates(not_surrounded_locations)

    expect(surrounded_stones).to_not include(*not_surrounded_coordinates)
  end

  it 'detects the trivial case' do
    trivial_surrounded_coordinates = locations_to_coordinates(trivial_surrounded_locations)
    expect(surrounded_stones).to include(*trivial_surrounded_coordinates)
  end

  it 'detects the edge and corner cases' do
    edge_and_corner_coordinates = locations_to_coordinates(edge_and_corner_locations)
    expect(surrounded_stones).to include(*edge_and_corner_coordinates)
  end

  it 'detects connected stones' do
    connected_coordinates = locations_to_coordinates(connected_locations)
    expect(surrounded_stones).to include(*connected_coordinates)
  end
end
