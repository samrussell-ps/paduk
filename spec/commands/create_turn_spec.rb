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

  context 'multiple calls, surrounding a piece' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 1),
        Coordinate.new(row: 0, column: 0)
      ]
    }
    let(:surrounding_coordinate) {
      Coordinate.new(row: 1, column: 0)
    }

    it 'removes the surrounded stone' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate).call
        # make stones now, work on previous turns later
        turn = Turn.last
        stone_addition = turn.stone_additions.first
        Stone.create!(row: stone_addition.row, column: stone_addition.column, color: turn.color)
      end


      expect(CreateTurn.new(surrounding_coordinate).call).to be true

      surrounding_turn = Turn.last

      expect(surrounding_turn.stone_additions.length).to eq(1)
      expect(surrounding_turn.stone_removals.length).to eq(1)

      stone_removal = surrounding_turn.stone_removals.first

      expect(stone_removal.row).to eq(0)
      expect(stone_removal.column).to eq(0)
    end
  end

  context 'multiple calls, stone already there' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 1),
      ]
    }
    let(:overlapping_coordinate) {
      Coordinate.new(row: 0, column: 1)
    }

    it 'returns false' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate).call
        # make stones now, work on previous turns later
        turn = Turn.last
        stone_addition = turn.stone_additions.first
        Stone.create!(row: stone_addition.row, column: stone_addition.column, color: turn.color)
      end

      expect(CreateTurn.new(overlapping_coordinate).call).to be false
    end

    it 'does not create a turn' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate).call
        # make stones now, work on previous turns later
        turn = Turn.last
        stone_addition = turn.stone_additions.first
        Stone.create!(row: stone_addition.row, column: stone_addition.column, color: turn.color)
      end

      expect { CreateTurn.new(overlapping_coordinate).call }.to_not change { Turn.count }
    end
  end
end
