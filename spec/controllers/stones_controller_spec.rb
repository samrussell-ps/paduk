require 'rails_helper'

RSpec.describe StonesController, type: :controller do
  describe '#create' do
    let(:row) { "3" }
    let(:column) { "7" }
    it 'tries to create a Stone with the row and column that are passed, and redirects to the index' do
      expect(Stone).to receive(:create!).with(row: row, column: column, color: anything).and_call_original

      post :create, row: row, column: column

      expect(response).to redirect_to stones_url
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
end