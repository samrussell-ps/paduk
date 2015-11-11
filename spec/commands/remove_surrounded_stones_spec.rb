require 'rails_helper'

describe RemoveSurroundedStones do
  def locations_to_coordinates(locations)
    coordinates = Set.new

    locations.each_with_index do |row, row_number|
      row.each_with_index do |cell, column_number|
        if cell > 0
          coordinates.add([row_number, column_number])
        end
      end
    end

    coordinates
  end

  let(:stone_locations) { 
    [
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 2, 0, 0, 0 ],
      [ 0, 0, 2, 1, 2, 0, 0 ],
      [ 0, 0, 0, 2, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ]
    ]
  }

  let(:coordinate_to_remove) { [3, 3] }

  before do
    colors = %w(none black white)

    locations_to_coordinates(stone_locations).each do |coordinate|
      color = colors[stone_locations[coordinate[0]][coordinate[1]]]
      Stone.create!(row: coordinate[0], column: coordinate[1], color: color)
    end
  end

  it 'removes the surrounded stone' do
    expect(Stone.where(row: coordinate_to_remove[0], column: coordinate_to_remove[1]).present?).to be true

    RemoveSurroundedStones.new('black').call

    expect(Stone.where(row: coordinate_to_remove[0], column: coordinate_to_remove[1]).present?).to be false
  end
end
