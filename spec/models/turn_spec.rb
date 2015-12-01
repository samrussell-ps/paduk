require 'rails_helper'

RSpec.describe Turn, type: :model do
  context 'with no additions, no removals' do
    subject { Turn.create }

    it { is_expected.to be_valid }
  end

  describe '#ordered' do
    context 'with no arguments' do
      before do
        Turn.destroy_all

        @turns = 5.times.map { Turn.create! }
      end

      it 'returns the turns ordered by creation date' do
        ordered = Turn.ordered

        expect(ordered.length).to eq(@turns.length)

        ordered.zip(@turns).each do |(turn, expected_turn)|
          expect(turn).to eq(expected_turn)
        end
      end
    end

    context 'with an id' do
      before do
        Turn.destroy_all

        @turns = 5.times.map { Turn.create! }
      end

      it 'returns the turns up to and including the given ID ordered by creation date' do
        first_three_turns = @turns.first(3)
        ordered = Turn.ordered(first_three_turns.last.id)

        expect(ordered.length).to eq(first_three_turns.length)

        ordered.zip(first_three_turns).each do |(turn, expected_turn)|
          expect(turn).to eq(expected_turn)
        end
      end
    end
  end
end
