require 'rails_helper'

describe Coordinate do
  let(:row) { 4 }
  let(:column) { 7 }
  let(:coordinate) { Coordinate.new(row: row, column: column) }

  it 'exposes row and column' do
    expect(coordinate.row).to eq(row)
    expect(coordinate.column).to eq(column)
  end

  describe '#neighbors' do
    let(:neighbors) { coordinate.neighbors }
    let(:expected_neighbors) { 
      [
        Coordinate.new(row: 4, column: 6),
        Coordinate.new(row: 4, column: 8),
        Coordinate.new(row: 3, column: 7),
        Coordinate.new(row: 5, column: 7)
      ]
    }

    it 'returns all the neighbors' do
      expect(neighbors).to contain_exactly(*expected_neighbors)
    end

    context 'corner and edge cases' do
      let(:corner_neighbors_1) { Coordinate.new(row: 0, column: 0).neighbors }
      let(:expected_corner_neighbors_1) {
        [
          Coordinate.new(row: 1, column: 0),
          Coordinate.new(row: 0, column: 1)
        ]
      }
      let(:corner_neighbors_2) { Coordinate.new(row: 18, column: 18).neighbors }
      let(:expected_corner_neighbors_2) {
        [
          Coordinate.new(row: 18, column: 17),
          Coordinate.new(row: 17, column: 18)
        ]
      }
      let(:edge_neighbors_1) { Coordinate.new(row: 0, column: 5).neighbors }
      let(:expected_edge_neighbors_1) {
        [
          Coordinate.new(row: 1, column: 5),
          Coordinate.new(row: 0, column: 4),
          Coordinate.new(row: 0, column: 6)
        ]
      }
      let(:edge_neighbors_2) { Coordinate.new(row: 5, column: 18).neighbors }
      let(:expected_edge_neighbors_2) {
        [
          Coordinate.new(row: 5, column: 17),
          Coordinate.new(row: 4, column: 18),
          Coordinate.new(row: 6, column: 18)
        ]
      }

      it 'returns all the neighbors' do
        expect(corner_neighbors_1).to contain_exactly(*expected_corner_neighbors_1)
        expect(corner_neighbors_2).to contain_exactly(*expected_corner_neighbors_2)
        expect(edge_neighbors_1).to contain_exactly(*expected_edge_neighbors_1)
        expect(edge_neighbors_2).to contain_exactly(*expected_edge_neighbors_2)
      end
    end
  end
end
