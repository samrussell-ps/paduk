require 'rails_helper'

RSpec.describe StoneRemoval, type: :model do
  let(:row) { 5 }
  let(:column) { 11 }
  let(:turn) { Turn.create!(color: 'white') }

  context 'with a row, column and turn' do
    subject { StoneRemoval.create(row: row, column: column, turn: turn) }

    it { is_expected.to be_valid }
  end

  context 'with a row, column and no turn' do
    subject { StoneRemoval.create(row: row, column: column, turn: nil) }

    it { is_expected.to be_invalid }
  end

  context 'with a row, turn and no column' do
    subject { StoneRemoval.create(row: row, column: nil, turn: turn) }

    it { is_expected.to be_invalid }
  end

  context 'with a column, turn and no row' do
    subject { StoneRemoval.create(row: nil, column: column, turn: turn) }

    it { is_expected.to be_invalid }
  end

  context 'with bad rows' do
    let(:bad_rows) { [-1, 19, -1234, 67] }

    it 'is invalid' do
      bad_rows.each do |bad_row|
        expect(StoneRemoval.create(row: bad_row, column: column, turn: turn)).to be_invalid
      end
    end
  end

  context 'with bad columns' do
    let(:bad_columns) { [-1, 19, -1234, 67] }

    it 'is invalid' do
      bad_columns.each do |bad_column|
        expect(StoneRemoval.create(row: row, column: bad_column, turn: turn)).to be_invalid
      end
    end
  end
end
