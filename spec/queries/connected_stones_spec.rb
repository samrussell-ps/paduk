require 'rails_helper'
require 'set'

describe ConnectedStones do
  # todo DRY
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
      [ 1, 1, 1, 1, 1, 0, 0 ],
      [ 1, 0, 1, 1, 1, 1, 1 ],
      [ 1, 0, 0, 0, 1, 1, 0 ],
      [ 1, 0, 1, 1, 0, 1, 0 ],
      [ 1, 1, 0, 0, 1, 1, 0 ],
      [ 1, 0, 1, 1, 1, 0, 1 ],
      [ 1, 1, 1, 1, 1, 0, 1 ]
    ]
  }
  let(:connected_stones1){
    [
      [ 1, 1, 1, 1, 1, 0, 0 ],
      [ 1, 0, 1, 1, 1, 1, 1 ],
      [ 1, 0, 0, 0, 1, 1, 0 ],
      [ 1, 0, 0, 0, 0, 1, 0 ],
      [ 1, 1, 0, 0, 1, 1, 0 ],
      [ 1, 0, 1, 1, 1, 0, 0 ],
      [ 1, 1, 1, 1, 1, 0, 0 ]
    ]
  }
  let(:connected_stones2) { 
    [
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 1 ],
      [ 0, 0, 0, 0, 0, 0, 1 ],
    ]
  }
  let(:connected_stones3) { 
    [
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 1, 1, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
    ]
  }
  let(:multicolor_stone_locations) { 
    [
      [ 0, 0, 1, 2, 2, 2, 0 ],
      [ 0, 0, 1, 2, 0, 2, 0 ],
      [ 0, 0, 1, 2, 2, 2, 0 ],
      [ 0, 1, 1, 2, 1, 2, 0 ],
      [ 1, 0, 1, 2, 1, 2, 0 ],
      [ 1, 0, 1, 1, 1, 0, 1 ],
      [ 1, 1, 0, 0, 0, 1, 1 ]
    ]
  }
  let(:multicolor_connected_stones1) { 
    [
      [ 0, 0, 1, 0, 0, 0, 0 ],
      [ 0, 0, 1, 0, 0, 0, 0 ],
      [ 0, 0, 1, 0, 0, 0, 0 ],
      [ 0, 1, 1, 0, 1, 0, 0 ],
      [ 0, 0, 1, 0, 1, 0, 0 ],
      [ 0, 0, 1, 1, 1, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
    ]
  }
  let(:board) { Board.new }

  context 'single color' do
    before do
      colors = %w(none black white)

      locations_to_coordinates(stone_locations).each do |coordinate|
        color = colors[stone_locations[coordinate.row][coordinate.column]]
        #Stone.create!(row: coordinate.row, column: coordinate.column, color: color)
        board.place(coordinate, color)
      end
    end

    it 'finds the easy (non-recursive) matches' do
      easy_coordinates2 = locations_to_coordinates(connected_stones2)
      easy_coordinates3 = locations_to_coordinates(connected_stones3)

      easy_coordinates2.each do |coordinate|
        connected_stones = ConnectedStones.new(board, coordinate, 'black').call
        expect(connected_stones).to contain_exactly(*easy_coordinates2)
      end

      easy_coordinates3.each do |coordinate|
        connected_stones = ConnectedStones.new(board, coordinate, 'black').call
        expect(connected_stones).to contain_exactly(*easy_coordinates3)
      end
    end

    it 'finds the hard (recursive) match' do
      hard_coordinates = locations_to_coordinates(connected_stones1)

      hard_coordinates.each do |coordinate|
        connected_stones = ConnectedStones.new(board, coordinate, 'black').call
        expect(connected_stones).to contain_exactly(*hard_coordinates)
      end
    end
  end

  context 'multiple colors' do
    before do
      colors = %w(none black white)

      locations_to_coordinates(multicolor_stone_locations).each do |coordinate|
        color = colors[multicolor_stone_locations[coordinate.row][coordinate.column]]
        #Stone.create!(row: coordinate.row, column: coordinate.column, color: color)
        board.place(coordinate, color)
      end
    end

    it 'works with multiple colors' do
      multicolor_coordinates1 = locations_to_coordinates(multicolor_connected_stones1)

      multicolor_coordinates1.each do |coordinate|
        connected_stones = ConnectedStones.new(board, coordinate, 'black').call
        expect(connected_stones).to contain_exactly(*multicolor_coordinates1)
      end
    end
  end
end
