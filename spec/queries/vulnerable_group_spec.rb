require 'rails_helper'

describe VulnerableGroup do
  let(:board) { Board.new}
  let(:coordinate) { Coordinate.new(row: 4, column: 4) }

  context 'when the stones have more than one liberty' do
    before do
      expect(LibertiesCount).to receive(:new).and_return(Proc.new { 2 })
    end

    subject { VulnerableGroup.new(board, coordinate).call }

    it { is_expected.to be false }
  end

  context 'when the stones have only one liberty' do
    before do
      expect(LibertiesCount).to receive(:new).and_return(Proc.new { 1 })
    end

    subject { VulnerableGroup.new(board, coordinate).call }

    it { is_expected.to be true }
  end
end
