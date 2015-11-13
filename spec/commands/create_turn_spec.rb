require 'rails_helper'

describe CreateTurn do
  context 'with a valid coordinate' do
    let(:coordinate) { Coordinate.new(row: 3, column: 7) }

    it 'creates a turn' do
      expect { CreateTurn.new(coordinate).call }.to change { Turn.count }.by(1)
    end

    it 'returns true and creates a turn with a single stone addition at that coordinate' do
      expect(CreateTurn.new(coordinate).call).to be true

      expect(Turn.last.stone_additions.length).to eq(1)

      expect(Turn.last.stone_additions.first.row).to eq(coordinate.row)
      expect(Turn.last.stone_additions.first.column).to eq(coordinate.column)
    end

    it 'creates a turn with no stone removal' do
      CreateTurn.new(coordinate).call

      expect(Turn.last.stone_removals.length).to eq(0)
    end
  end

  context 'with no coordinate' do
    let(:coordinate) { nil }

    it 'creates a turn' do
      expect { CreateTurn.new(coordinate).call }.to change { Turn.count }.by(1)
    end

    it 'returns true and creates a turn with no stone addition at that coordinate' do
      expect(CreateTurn.new(coordinate).call).to be true

      expect(Turn.last.stone_additions.length).to eq(0)
    end

    it 'creates a turn with no stone removal' do
      CreateTurn.new(coordinate).call

      expect(Turn.last.stone_removals.length).to eq(0)
    end
  end

  context 'multiple calls' do
    let(:coordinates) { 4.times.map { nil } }

    it 'alternates colors' do
      coordinates.each do |coordinate|
        CreateTurn.new(coordinate).call
      end

      turns = Turn.last(4)
      
      expect(turns[1].color).to eq(turns[3].color)
      expect(turns[0].color).to eq(turns[2].color)

      expect(turns[0].color).to_not eq(turns[3].color)
      expect(turns[1].color).to_not eq(turns[2].color)
    end
  end
end
