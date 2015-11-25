require 'rails_helper'

RSpec.describe StoneAddition, type: :model do
  let(:row) { 5 }
  let(:column) { 11 }
  let(:turn) { Turn.create!(color: 'white') }

  context 'with a row, column and turn' do
    subject(:stone_addition) { StoneAddition.create(row: row, column: column, turn: turn) }

    it { is_expected.to be_valid }

    describe '#to_coordinate' do
      let(:expected_coordinate) { Coordinate.new(row: row, column: column) }
      subject { stone_addition.to_coordinate }

      it { is_expected.to eq expected_coordinate }
    end
  end

  context 'with a row, column and no turn' do
    subject { StoneAddition.create(row: row, column: column, turn: nil) }

    it { is_expected.to be_invalid }
  end

  context 'with a row, turn and no column' do
    subject { StoneAddition.create(row: row, column: nil, turn: turn) }

    it { is_expected.to be_invalid }
  end

  context 'with a column, turn and no row' do
    subject { StoneAddition.create(row: nil, column: column, turn: turn) }

    it { is_expected.to be_invalid }
  end

  context 'with bad rows' do
    let(:bad_rows) { [-1, 19, -1234, 67] }

    it 'is invalid' do
      bad_rows.each do |bad_row|
        expect(StoneAddition.create(row: bad_row, column: column, turn: turn)).to be_invalid
      end
    end
  end

  context 'with bad columns' do
    let(:bad_columns) { [-1, 19, -1234, 67] }

    it 'is invalid' do
      bad_columns.each do |bad_column|
        expect(StoneAddition.create(row: row, column: bad_column, turn: turn)).to be_invalid
      end
    end
  end
end
