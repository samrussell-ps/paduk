require 'rails_helper'

describe NextColor do
  let(:board) { Board.new }
  subject(:next_color) { NextColor.new.call }

  before do
    Turn.all.each { |turn| turn.destroy! }
  end

  context 'with no turns' do
    it { is_expected.to eq('black') }
  end

  context 'with one turn' do
    before do
      CreateTurn.new(nil, board).call

      ApplyTurn.new(Turn.last, board).call
    end

    it { is_expected.to eq('white') }
  end

  context 'with two turns' do
    before do
      coordinates = [
        Coordinate.new(row: 3, column: 5),
        Coordinate.new(row: 7, column: 8)
      ]
      
      coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call

        ApplyTurn.new(Turn.last, board).call
      end
    end

    it { is_expected.to eq('black') }
  end
end
