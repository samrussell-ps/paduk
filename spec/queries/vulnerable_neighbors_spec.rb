require 'rails_helper'
require 'set'
require 'helper_methods'

describe VulnerableNeighbors do
  let(:stone_locations) { 
    [
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 2, 2, 2, 0, 0 ],
      [ 0, 2, 1, 0, 1, 2, 0 ],
      [ 0, 0, 2, 1, 1, 2, 0 ],
      [ 0, 0, 2, 1, 1, 2, 0 ],
      [ 0, 0, 0, 2, 2, 0, 0 ]
    ]
  }

  let(:vulnerable_neighbors_locations) { 
    [
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ],
      [ 0, 0, 1, 0, 1, 0, 0 ],
      [ 0, 0, 0, 1, 1, 0, 0 ],
      [ 0, 0, 0, 1, 1, 0, 0 ],
      [ 0, 0, 0, 0, 0, 0, 0 ]
    ]
  }

  let(:next_move_coordinate) { Coordinate.new(row: 3, column: 3) }

  let(:board) { Board.new }

  before do
    init_board(stone_locations)
  end

  it 'finds the vulnerable neighbors' do
    expected_vulnerable_neighbors = locations_to_coordinates(vulnerable_neighbors_locations)

    vulnerable_neighbors = VulnerableNeighbors.new(board, next_move_coordinate, 'white').call

    expect(vulnerable_neighbors).to contain_exactly(*expected_vulnerable_neighbors)
  end
end
