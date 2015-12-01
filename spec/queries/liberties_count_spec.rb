require 'rails_helper'
require 'helper_methods'

describe LibertiesCount do
  let(:stone_locations) { 
    [
      [ 2, 0, 1, 0, 1, 0, 1 ],
      [ 0, 0, 1, 2, 1, 0, 1 ],
      [ 1, 0, 1, 0, 1, 0, 1 ],
      [ 2, 0, 1, 1, 1, 1, 1 ],
      [ 1, 0, 1, 2, 0, 0, 1 ],
      [ 1, 0, 2, 2, 1, 0, 1 ],
      [ 1, 1, 1, 1, 1, 0, 1 ]
    ]
  }
  let(:board) { Board.new }

  before do
    init_board(stone_locations)
  end

  context 'single stone' do
    it 'counts liberties correctly' do
      expect(LibertiesCount.new(board, Coordinate.new(row: 0, column: 0)).call).to eq(2)
      expect(LibertiesCount.new(board, Coordinate.new(row: 1, column: 3)).call).to eq(2)
      expect(LibertiesCount.new(board, Coordinate.new(row: 3, column: 0)).call).to eq(1)
    end
  end

  context 'multiple stones' do
    it 'counts liberties correctly' do
      expect(LibertiesCount.new(board, Coordinate.new(row: 5, column: 2)).call).to eq(2)
      expect(LibertiesCount.new(board, Coordinate.new(row: 5, column: 3)).call).to eq(2)
      expect(LibertiesCount.new(board, Coordinate.new(row: 4, column: 3)).call).to eq(2)
    end
  end

  context 'multiple stones, shared liberties' do
    it 'counts liberties correctly' do
      expect(LibertiesCount.new(board, Coordinate.new(row: 4, column: 0)).call).to eq(10)
    end
  end
end
