require 'rails_helper'

describe CreateTurn do
  let(:board) { Board.new }

  context 'with a valid coordinate' do
    let(:coordinate) { Coordinate.new(row: 3, column: 7) }

    it 'creates a turn' do
      expect { CreateTurn.new(coordinate, board).call }.to change { Turn.count }.by(1)
    end

    it 'returns true and creates a turn with a single stone addition at that coordinate' do
      expect(CreateTurn.new(coordinate, board).call).to be true

      expect(Turn.last.stone_additions.length).to eq(1)

      expect(Turn.last.stone_additions.first.row).to eq(coordinate.row)
      expect(Turn.last.stone_additions.first.column).to eq(coordinate.column)
    end

    it 'creates a turn with no stone removal' do
      CreateTurn.new(coordinate, board).call

      expect(Turn.last.stone_removals.length).to eq(0)
    end
  end

  context 'with no coordinate' do
    let(:coordinate) { nil }

    it 'creates a turn' do
      expect { CreateTurn.new(coordinate, board).call }.to change { Turn.count }.by(1)
    end

    it 'returns true and creates a turn with no stone addition at that coordinate' do
      expect(CreateTurn.new(coordinate, board).call).to be true

      expect(Turn.last.stone_additions.length).to eq(0)
    end

    it 'creates a turn with no stone removal' do
      CreateTurn.new(coordinate, board).call

      expect(Turn.last.stone_removals.length).to eq(0)
    end
  end

  context 'multiple calls' do
    let(:coordinates) { 4.times.map { nil } }

    it 'alternates colors' do
      coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
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
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect(CreateTurn.new(surrounding_coordinate, board).call).to be true

      surrounding_turn = Turn.last

      expect(surrounding_turn.stone_additions.length).to eq(1)
      expect(surrounding_turn.stone_removals.length).to eq(1)

      stone_removal = surrounding_turn.stone_removals.first

      expect(stone_removal.row).to eq(0)
      expect(stone_removal.column).to eq(0)
    end
  end

  context 'multiple calls, surrounding multiple pieces' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 1),
        Coordinate.new(row: 0, column: 0),
        Coordinate.new(row: 1, column: 1),
        Coordinate.new(row: 1, column: 0)
      ]
    }

    let(:surrounding_coordinate) {
      Coordinate.new(row: 2, column: 0)
    }

    let(:removed_coordinates) {
      [
        Coordinate.new(row: 0, column: 0),
        Coordinate.new(row: 1, column: 0)
      ]
    }

    it 'removes the surrounded stones' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect(CreateTurn.new(surrounding_coordinate, board).call).to be true

      surrounding_turn = Turn.last

      expect(surrounding_turn.stone_additions.length).to eq(1)
      expect(surrounding_turn.stone_removals.length).to eq(2)

      stone_removal = surrounding_turn.stone_removals.first

      removed_coordinates = surrounding_turn.stone_removals.map { |stone_removal| Coordinate.new(row: stone_removal.row, column: stone_removal.column) }
      expect(removed_coordinates).to contain_exactly(*removed_coordinates)
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
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect(CreateTurn.new(overlapping_coordinate, board).call).to be false
    end

    it 'does not create a turn' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect { CreateTurn.new(overlapping_coordinate, board).call }.to_not change { Turn.count }
    end
  end
  
  context 'multiple calls, connecting to self' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 1),
        Coordinate.new(row: 0, column: 5),
        Coordinate.new(row: 1, column: 2),
        Coordinate.new(row: 1, column: 4),
        Coordinate.new(row: 0, column: 4),
        Coordinate.new(row: 1, column: 3),
      ]
    }
    let(:final_coordinate) {
      Coordinate.new(row: 0, column: 3)
    }

    it 'returns true' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect(CreateTurn.new(final_coordinate, board).call).to be true
    end

    it 'creates a turn' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect { CreateTurn.new(final_coordinate, board).call }.to change { Turn.count }.by(1)
    end

    it 'does not remove any pieces' do
    end
  end

  context 'multiple calls, retaking (ko rule)' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 1),
        Coordinate.new(row: 0, column: 4),
        Coordinate.new(row: 1, column: 2),
        Coordinate.new(row: 1, column: 3),
        Coordinate.new(row: 0, column: 3),
        Coordinate.new(row: 0, column: 2)
      ]
    }
    let(:retaking_coordinate) {
      Coordinate.new(row: 0, column: 3)
    }

    it 'returns false' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect(CreateTurn.new(retaking_coordinate, board).call).to be false
    end

    it 'does not create a turn' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect { CreateTurn.new(retaking_coordinate, board).call }.to_not change { Turn.count }
    end
  end
  
  context 'multiple calls, retaking (not ko rule)' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 1),
        Coordinate.new(row: 0, column: 5),
        Coordinate.new(row: 1, column: 2),
        Coordinate.new(row: 1, column: 4),
        Coordinate.new(row: 0, column: 4),
        Coordinate.new(row: 1, column: 3),
        Coordinate.new(row: 0, column: 3),
        Coordinate.new(row: 0, column: 2),
      ]
    }
    let(:retaking_coordinate) {
      Coordinate.new(row: 0, column: 3)
    }

    it 'returns true' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect(CreateTurn.new(retaking_coordinate, board).call).to be true
    end

    it 'creates a turn' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect { CreateTurn.new(retaking_coordinate, board).call }.to change { Turn.count }.by(1)
    end
  end

  context 'multiple calls, suicide rule' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 1),
        nil,
        Coordinate.new(row: 1, column: 2),
        nil,
        Coordinate.new(row: 0, column: 3),
      ]
    }
    let(:suicide_coordinate) {
      Coordinate.new(row: 0, column: 2)
    }

    it 'returns false' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect(CreateTurn.new(suicide_coordinate, board).call).to be false
    end

    it 'does not create a turn' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect { CreateTurn.new(suicide_coordinate, board).call }.to_not change { Turn.count }
    end
  end

  context 'multiple calls, suicide rule, connects to chain' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 1),
        nil,
        Coordinate.new(row: 1, column: 2),
        Coordinate.new(row: 0, column: 2),
        Coordinate.new(row: 1, column: 3),
        nil,
        Coordinate.new(row: 0, column: 4),
      ]
    }
    let(:suicide_coordinate) {
      Coordinate.new(row: 0, column: 3)
    }

    it 'returns false' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect(CreateTurn.new(suicide_coordinate, board).call).to be false
    end

    it 'does not create a turn' do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end

      expect { CreateTurn.new(suicide_coordinate, board).call }.to_not change { Turn.count }
    end
  end
end
