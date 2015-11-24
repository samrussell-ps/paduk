require 'rails_helper'

describe Board do
  let(:board) { Board.new }

  it 'is full of empty squares' do
    19.times.each do |row|
      19.times.each do |column|
        expect(board.square(Coordinate.new(row: row, column: column))).to_not be
      end
    end
  end

  describe '#place' do
    it 'adds a color to the square' do
      expect { board.place(Coordinate.new(row: 5, column: 7), 'white') }.to change { board.square(Coordinate.new(row: 5, column: 7)) }.from(nil).to('white')
    end
  end

  describe '#remove' do
    it 'removes a color from the square' do
      board.place(Coordinate.new(row: 5, column: 7), 'white')
      expect { board.remove(Coordinate.new(row: 5, column: 7)) }.to change { board.square(Coordinate.new(row: 5, column: 7)) }.from('white').to(nil)
    end
  end

  describe '#to_s' do
    let(:expected_to_s) { <<-TOS.gsub(/ {6}/, '')
      ...................
      .o.................
      ...x...............
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      ...................
      TOS
    }

    it 'prints the board' do
      board.place(Coordinate.new(row: 1, column: 1), 'white')
      board.place(Coordinate.new(row: 2, column: 3), 'black')

      expect(board.to_s).to eq(expected_to_s)
    end
  end
end