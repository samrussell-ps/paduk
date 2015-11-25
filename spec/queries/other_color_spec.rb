require 'rails_helper'

describe OtherColor do
  it 'returns the other color' do
    expect(OtherColor.new('black').call).to eq('white')
    expect(OtherColor.new('white').call).to eq('black')
  end
end
