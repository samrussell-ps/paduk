require 'rails_helper'

describe ApplyTurn do
  it 'places stones where there are stone additions' do
    turn = Turn.create!(color: 'black')
    board = Board.new

    turn.stone_additions.create!(row: 3, column: 4)

    expect { ApplyTurn.new(turn, board).call }.to change { board.color_at(Coordinate.new(row: 3, column: 4)) }.from(nil).to('black')
  end

  it 'removes stones where there are stone removals' do
    turn = Turn.create!(color: 'black')
    board = Board.new

    turn.stone_additions.create!(row: 3, column: 4)
    turn.stone_removals.create!(row: 2, column: 5)
    turn.stone_removals.create!(row: 6, column: 7)

    board.place(Coordinate.new(row: 2, column: 5), 'white')
    board.place(Coordinate.new(row: 6, column: 7), 'white')

    expect(board.color_at(Coordinate.new(row: 2, column: 5))).to eq('white')
    expect(board.color_at(Coordinate.new(row: 6, column: 7))).to eq('white')

    ApplyTurn.new(turn, board).call

    expect(board.color_at(Coordinate.new(row: 2, column: 5))).to eq(nil)
    expect(board.color_at(Coordinate.new(row: 6, column: 7))).to eq(nil)
  end
end
