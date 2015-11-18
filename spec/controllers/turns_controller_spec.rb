require 'rails_helper'

RSpec.describe TurnsController, type: :controller do
  let(:row) { "3" }
  let(:column) { "7" }

  describe '#create' do
    it 'redirects to index' do
      post :create, row: row, column: column

      expect(response).to redirect_to turns_url
    end

    context 'with valid coordinates' do
      it 'creates a turn' do
        expect { post :create, row: row, column: column }.to change{ Turn.count }.by(1)
      end
    end

    context 'with no coordinates' do
      previous_turn = Turn.create!(color: 'black')

      previous_turn.stone_additions.create!(row: 0, column: 0)

      it 'creates a turn' do
        expect { post :create }.to change{ Turn.count }.by(1)
      end
    end
  end

  describe '#index' do
    it 'renders the page' do
      get :index

      expect(response.status).to eq(200)
    end
  end

  describe '#show' do
    it 'renders the page' do
      turn = Turn.create!(color: 'white')

      get :show, id: turn.id

      expect(response.status).to eq(200)
    end
  end

  describe '#destroy' do
    it 'redirects to index' do
      delete :destroy, id: 1

      expect(response).to redirect_to turns_url
    end
  end
end
