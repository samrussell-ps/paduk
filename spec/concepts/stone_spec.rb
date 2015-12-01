require 'rails_helper'

describe Stone do
  describe '#color' do
    context 'black' do
      subject { Stone.new(color: :black).color }

      it { is_expected.to be :black }
    end

    context 'white' do
      subject { Stone.new(color: :white).color }

      it { is_expected.to be :white }
    end

    context 'nil' do
      subject { Stone.new.color }

      it { is_expected.to be nil }
    end
  end

  describe '#empty_square?' do
    context 'black' do
      subject { Stone.new(color: :black).empty_square? }

      it { is_expected.to be false }
    end

    context 'white' do
      subject { Stone.new(color: :white).empty_square? }

      it { is_expected.to be false }
    end

    context 'nil' do
      subject { Stone.new.empty_square? }

      it { is_expected.to be true }
    end
  end
end
