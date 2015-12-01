require 'rails_helper'

describe ApplyTurn do
  let(:empty_square_stone) { Stone.new(color: nil) }
  let(:white_stone) { Stone.new(color: 'white') }
  let(:black_stone) { Stone.new(color: 'black') }

  it 'places stones where there are stone additions' do
    turn = Turn.create!(color: 'black')
    board = Board.new

    turn.stone_additions.create!(row: 3, column: 4)

    expect { ApplyTurn.new(turn, board).call }.to change { board.stone_at(Coordinate.new(row: 3, column: 4)) }.from(empty_square_stone).to(black_stone)
  end

  it 'removes stones where there are stone removals' do
    turn = Turn.create!(color: 'black')
    board = Board.new

    turn.stone_additions.create!(row: 3, column: 4)
    turn.stone_removals.create!(row: 2, column: 5)
    turn.stone_removals.create!(row: 6, column: 7)

    board.place(Coordinate.new(row: 2, column: 5), white_stone)
    board.place(Coordinate.new(row: 6, column: 7), white_stone)

    expect(board.stone_at(Coordinate.new(row: 2, column: 5))).to eq(white_stone)
    expect(board.stone_at(Coordinate.new(row: 6, column: 7))).to eq(white_stone)

    ApplyTurn.new(turn, board).call

    expect(board.stone_at(Coordinate.new(row: 2, column: 5))).to eq(empty_square_stone)
    expect(board.stone_at(Coordinate.new(row: 6, column: 7))).to eq(empty_square_stone)
  end
end
