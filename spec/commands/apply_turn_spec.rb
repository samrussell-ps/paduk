require 'rails_helper'

describe ApplyTurn do
  it 'creates stones where there are stone additions' do
    turn = Turn.create!(color: 'black')
    turn.stone_additions.create!(row: 3, column: 4)

    expect { ApplyTurn.new(turn).call }.to change { Stone.count }.by(1)
    expect(Stone.last.row).to eq(3)
    expect(Stone.last.column).to eq(4)
    expect(Stone.last.color).to eq(turn.color)
  end

  it 'removes stones where there are stone removals' do
    turn = Turn.create!(color: 'black')
    turn.stone_additions.create!(row: 3, column: 4)
    turn.stone_removals.create!(row: 2, column: 5)
    turn.stone_removals.create!(row: 6, column: 7)

    Stone.create!(row: 2, column: 5, color: 'white')
    Stone.create!(row: 6, column: 7, color: 'white')

    expect(Stone.where(row: 2, column: 5).present?).to be true
    expect(Stone.where(row: 6, column: 7).present?).to be true

    expect { ApplyTurn.new(turn).call }.to change { Stone.count }.by(-1)

    expect(Stone.where(row: 2, column: 5).present?).to be false
    expect(Stone.where(row: 6, column: 7).present?).to be false
  end
end
