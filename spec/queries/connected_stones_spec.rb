require 'rails_helper'
require 'set'
require 'helper_methods'

describe ConnectedStones do
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

  let(:connected_stones1) {
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
      init_board(stone_locations)
    end

    it 'finds the easy (non-recursive) matches' do
      easy_coordinates2 = locations_to_coordinates(connected_stones2)
      easy_coordinates3 = locations_to_coordinates(connected_stones3)

      easy_coordinates2.each do |coordinate|
        connected_stones = ConnectedStones.new(board, coordinate).call
        expect(connected_stones).to contain_exactly(*easy_coordinates2)
      end

      easy_coordinates3.each do |coordinate|
        connected_stones = ConnectedStones.new(board, coordinate).call
        expect(connected_stones).to contain_exactly(*easy_coordinates3)
      end
    end

    it 'finds the hard (recursive) match' do
      hard_coordinates = locations_to_coordinates(connected_stones1)

      hard_coordinates.each do |coordinate|
        connected_stones = ConnectedStones.new(board, coordinate).call
        expect(connected_stones).to contain_exactly(*hard_coordinates)
      end
    end
  end

  context 'multiple colors' do
    before do
      init_board(multicolor_stone_locations)
    end

    it 'works with multiple colors' do
      multicolor_coordinates1 = locations_to_coordinates(multicolor_connected_stones1)

      multicolor_coordinates1.each do |coordinate|
        connected_stones = ConnectedStones.new(board, coordinate).call
        expect(connected_stones).to contain_exactly(*multicolor_coordinates1)
      end
    end
  end
end
