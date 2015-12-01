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

    context 'blue' do
      subject { Stone.new(color: :blue).color }

      it { is_expected.to be nil }
    end
  end
end
