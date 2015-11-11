require 'rails_helper'

RSpec.describe StonesController, type: :controller do
  describe '#create' do
    let(:row) { "3" }
    let(:column) { "7" }
    it 'tries to create a Stone with the row and column that are passed' do
      expect(Stone).to receive(:create!).with(row: row, column: column, color: anything).and_call_original

      post :create, row: row, column: column
    end
  end
end
