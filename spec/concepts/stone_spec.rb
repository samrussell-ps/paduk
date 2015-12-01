require 'rails_helper'

describe Stone do
  describe '#color' do
    context 'black' do
      subject { Stone.new(color: 'black').color }

      it { is_expected.to eq 'black' }
    end

    context 'white' do
      subject { Stone.new(color: 'white').color }

      it { is_expected.to eq 'white' }
    end

    context 'nil' do
      subject { Stone.new.color }

      it { is_expected.to be nil }
    end
  end

  describe '#empty_square?' do
    context 'black' do
      subject { Stone.new(color: 'black').empty_square? }

      it { is_expected.to be false }
    end

    context 'white' do
      subject { Stone.new(color: 'white').empty_square? }

      it { is_expected.to be false }
    end

    context 'nil' do
      subject { Stone.new.empty_square? }

      it { is_expected.to be true }
    end
  end

  describe 'equality' do
    let(:stone1) { Stone.new(color: 'white') } 
    let(:stone2) { Stone.new(color: 'white') } 
    let(:stone3) { Stone.new(color: 'black') } 

    it 'compares correctly' do
      expect(stone1).to eq(stone2)
      expect(stone3).to_not eq(stone2)
      expect(stone1).to_not eq(stone3)

      expect([stone1, stone2].uniq).to eq([stone1])
    end
  end
end
