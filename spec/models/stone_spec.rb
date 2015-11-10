require 'rails_helper'

RSpec.describe Stone, type: :model do
  context 'with a row and a column' do
    subject(:stone) { Stone.create(row: 3, column: 2) }
    
    it { is_expected.to be_valid }
  end

  context 'with a row and a no column' do
    subject(:stone) { Stone.create(row: 3, column: nil) }
    
    it { is_expected.to be_invalid }
  end

  context 'with a column and no row' do
    subject(:stone) { Stone.create(row: nil, column: 2) }
    
    it { is_expected.to be_invalid }
  end
end
