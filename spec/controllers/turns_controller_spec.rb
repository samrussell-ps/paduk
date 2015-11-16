require 'rails_helper'

RSpec.describe TurnsController, type: :controller do
  let(:row) { "3" }
  let(:column) { "7" }

  describe '#create' do
    it 'redirects to index' do
      post :create, row: row, column: column

      expect(response).to redirect_to turns_url
    end
  end

  describe '#index' do
    it 'renders the page' do
      get :index

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
