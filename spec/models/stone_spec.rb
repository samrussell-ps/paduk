require 'rails_helper'

RSpec.describe Stone, type: :model do
  context 'with a row and a column and a color' do
    subject(:stone) { Stone.create(row: 3, column: 2, color: 'black') }
    
    it { is_expected.to be_valid }
  end

  context 'with a row and a color a no column' do
    subject(:stone) { Stone.create(row: 3, column: nil, color: 'black') }
    
    it { is_expected.to be_invalid }
  end

  context 'with a column and a color and no row' do
    subject(:stone) { Stone.create(row: nil, column: 2, color: 'black') }
    
    it { is_expected.to be_invalid }
  end

  context 'with a row and a column and no color' do
    subject(:stone) { Stone.create(row: 3, column: 2, color: nil) }
    
    it { is_expected.to be_invalid }
  end

  context 'with a row and a column and bad color' do
    subject(:stone) { Stone.create(row: 3, column: 2, color: 'blue') }
    
    it { is_expected.to be_invalid }
  end
end
