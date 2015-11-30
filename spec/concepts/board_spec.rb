require 'rails_helper'

describe Board do
  let(:board) { Board.new }

  it 'is full of empty squares' do
    19.times.each do |row|
      19.times.each do |column|
        expect(board.color_at(Coordinate.new(row: row, column: column))).to_not be
      end
    end
  end

  describe '#place' do
    it 'adds a color to the square' do
      expect { board.place(Coordinate.new(row: 5, column: 7), 'white') }.to change { board.color_at(Coordinate.new(row: 5, column: 7)) }.from(nil).to('white')
    end
  end

  describe '#remove' do
    it 'removes a color from the square' do
      board.place(Coordinate.new(row: 5, column: 7), 'white')
      expect { board.remove(Coordinate.new(row: 5, column: 7)) }.to change { board.color_at(Coordinate.new(row: 5, column: 7)) }.from('white').to(nil)
    end
  end

  describe '#removed_stones' do
    let(:coordinates) {
      [
        Coordinate.new(row: 1, column: 0),
        Coordinate.new(row: 0, column: 0),
        Coordinate.new(row: 0, column: 1),
        Coordinate.new(row: 1, column: 1),
        Coordinate.new(row: 2, column: 1),
        Coordinate.new(row: 2, column: 0),
        Coordinate.new(row: 3, column: 1),
        Coordinate.new(row: 3, column: 0),
        Coordinate.new(row: 4, column: 0),
        Coordinate.new(row: 2, column: 0),
        Coordinate.new(row: 2, column: 2),
        Coordinate.new(row: 0, column: 0),
        Coordinate.new(row: 1, column: 2),
        Coordinate.new(row: 0, column: 2)
      ]
    }
    let(:removed_stones) { board.removed_stones }

    it 'returns removed stones by color' do
      Turn.destroy_all

      coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        ApplyTurn.new(Turn.last, board).call
      end

      expect(removed_stones['black']).to eq(2)
      expect(removed_stones['white']).to eq(3)
    end
  end

  describe '#to_s' do
    let(:expected_to_s) { <<-TOS.strip_heredoc.chomp
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

  describe '#as_json' do
    let(:expected_as_json) {
      { 'removed_stones' => { 'black' => 2, 'white' => 1 },
        'stones' => {
          'black' => [
            { 'row' => 4, 'column' => 3 },
            { 'row' => 6, 'column' => 7 }
          ],
          'white' => [
            { 'row' => 4, 'column' => 1 },
            { 'row' => 6, 'column' => 5 }
          ]
        }
      }
    }

    before do
      board.place(Coordinate.new(row: 1, column: 1), 'white')
      board.place(Coordinate.new(row: 2, column: 3), 'black')
      board.place(Coordinate.new(row: 2, column: 4), 'black')
      board.remove(Coordinate.new(row: 1, column: 1))
      board.remove(Coordinate.new(row: 2, column: 3))
      board.remove(Coordinate.new(row: 2, column: 4))

      board.place(Coordinate.new(row: 4, column: 1), 'white')
      board.place(Coordinate.new(row: 4, column: 3), 'black')
      board.place(Coordinate.new(row: 6, column: 5), 'white')
      board.place(Coordinate.new(row: 6, column: 7), 'black')
    end

    it 'produces expected JSON' do
      expect(board.as_json).to eq(expected_as_json)
    end
  end
end
