require 'rails_helper'

RSpec.describe StonesController, type: :controller do
  def locations_to_coordinates(locations)
    coordinates = Set.new

    locations.each_with_index do |row, row_number|
      row.each_with_index do |cell, column_number|
        if cell > 0
          coordinates.add([row_number, column_number])
        end
      end
    end

    coordinates
  end

  describe '#create' do
    let(:row) { "3" }
    let(:column) { "7" }
    it 'tries to create a Stone with the row and column that are passed, and redirects to the index' do
      expect(Stone).to receive(:create!).with(row: row, column: column, color: anything).and_call_original

      post :create, row: row, column: column

      expect(response).to redirect_to stones_url
    end

    context 'surrounding stones' do
      let(:stone_locations) { 
        [
          [ 0, 0, 0, 0, 0, 0, 0 ],
          [ 0, 0, 0, 0, 0, 0, 0 ],
          [ 0, 0, 0, 2, 0, 0, 0 ],
          [ 0, 0, 2, 1, 0, 0, 0 ],
          [ 0, 0, 0, 2, 0, 0, 0 ],
          [ 0, 0, 0, 0, 0, 0, 0 ],
          [ 0, 0, 0, 0, 0, 0, 0 ]
        ]
      }

      let(:row) { "3" }
      let(:column) { "4" }
      let(:coordinate_to_remove) { [3, 3] }
      let(:stone_to_remove) { Stone.where(row: coordinate_to_remove[0], column: coordinate_to_remove[1]).first }

      before do
        colors = %w(none black white)

        locations_to_coordinates(stone_locations).each do |coordinate|
          color = colors[stone_locations[coordinate[0]][coordinate[1]]]
          Stone.create!(row: coordinate[0], column: coordinate[1], color: color)
        end

        Stone.create!(row: 6, column: 6, color: 'black')
      end

      it 'remove surrounded stones of the other color after a move is made' do
        expect(Stone).to receive(:create!).with(row: row, column: column, color: 'white').and_call_original
        expect(RemoveSurroundedStones).to receive(:new).with('black').and_call_original

        post :create, row: row, column: column
      end
    end
  end

  describe '#index' do
    it 'renders the page' do
      get :index

      expect(response.status).to eq(200)
    end
  end

  describe '#new' do
    it 'renders the page' do
      get :new

      expect(response.status).to eq(200)
    end
  end

  describe '#destroy' do
    it 'tries to destroy the Stone with the id that is passed' do
      stone = Stone.create!(row: "3", column: "7", color: "black")

      expect { delete :destroy, id: stone.id }.to change { Stone.count }.by(-1)
    end
      
    it 'redirects to the index' do
      stone = Stone.create!(row: "3", column: "7", color: "black")

      delete :destroy, id: stone.id

      expect(response).to redirect_to stones_url
    end
  end
end
