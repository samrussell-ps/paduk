require 'rails_helper'

describe LibertiesCount do
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
    colors = %w(none black white)

    locations_to_coordinates(stone_locations).each do |coordinate|
      color = colors[stone_locations[coordinate.row][coordinate.column]]
      #Stone.create!(row: coordinate.row, column: coordinate.column, color: color)
      board.place(coordinate, color)
    end
  end

  context 'single stone' do
    it 'counts liberties correctly' do
      expect(LibertiesCount.new(board, Coordinate.new(row: 0, column: 0), 'white').call).to eq(2)
      expect(LibertiesCount.new(board, Coordinate.new(row: 1, column: 3), 'white').call).to eq(2)
      expect(LibertiesCount.new(board, Coordinate.new(row: 3, column: 0), 'white').call).to eq(1)
    end
  end

  context 'multiple stones' do
    it 'counts liberties correctly' do
      expect(LibertiesCount.new(board, Coordinate.new(row: 5, column: 2), 'white').call).to eq(2)
      expect(LibertiesCount.new(board, Coordinate.new(row: 5, column: 3), 'white').call).to eq(2)
      expect(LibertiesCount.new(board, Coordinate.new(row: 4, column: 3), 'white').call).to eq(2)
    end
  end

  context 'multiple stones, shared liberties' do
    it 'counts liberties correctly' do
      expect(LibertiesCount.new(board, Coordinate.new(row: 4, column: 0), 'black').call).to eq(10)
    end
  end
end
