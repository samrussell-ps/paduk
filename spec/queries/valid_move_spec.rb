require 'rails_helper'

describe ValidMove do
  let(:board) { Board.new }

  context 'with a valid coordinate' do
    let(:coordinate) { Coordinate.new(row: 3, column: 7) }

    it 'is true' do
      expect(ValidMove.new(coordinate, board).call).to be true
    end
  end

  context 'with no coordinate' do
    let(:coordinate) { nil }

    it 'is true' do
      expect(ValidMove.new(coordinate, board).call).to be true
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

    before do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is true' do
      expect(ValidMove.new(surrounding_coordinate, board).call).to be true
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

    before do
      previous_coordinates.each do |coordinate|
        ValidMove.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is true' do
      expect(ValidMove.new(surrounding_coordinate, board).call).to be true
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

    before do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is false' do
      expect(ValidMove.new(overlapping_coordinate, board).call).to be false
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

    before do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is true' do
      expect(ValidMove.new(final_coordinate, board).call).to be true
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

    before do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is false' do
      expect(ValidMove.new(retaking_coordinate, board).call).to be false
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
   
    before do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is true' do
      expect(ValidMove.new(retaking_coordinate, board).call).to be true
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

    before do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is false' do
      expect(ValidMove.new(suicide_coordinate, board).call).to be false
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

    before do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is false' do
      expect(ValidMove.new(suicide_coordinate, board).call).to be false
    end
  end

  context 'multiple calls, play in surrounded square (not suicide rule)' do
    let(:previous_coordinates) {
      [
        Coordinate.new(row: 0, column: 2),
        Coordinate.new(row: 0, column: 1),
        Coordinate.new(row: 1, column: 2),
        Coordinate.new(row: 1, column: 1),
        Coordinate.new(row: 2, column: 2),
        Coordinate.new(row: 1, column: 0),
        Coordinate.new(row: 2, column: 1),
        nil,
        Coordinate.new(row: 2, column: 0),
        nil
      ]
    }
    let(:final_coordinate) {
      Coordinate.new(row: 0, column: 0)
    }

    before do
      previous_coordinates.each do |coordinate|
        CreateTurn.new(coordinate, board).call
        turn = Turn.last
        ApplyTurn.new(turn, board).call
      end
    end

    it 'is true' do
      expect(ValidMove.new(final_coordinate, board).call).to be true
    end
  end
end
