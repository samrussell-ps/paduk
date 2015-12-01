require 'rails_helper'

RSpec.describe Turn, type: :model do
  context 'with no additions, no removals' do
    subject { Turn.create }

    it { is_expected.to be_valid }
  end

  describe '.ordered' do
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

  describe '.with_table_lock' do
    it 'executes the block passed to it' do
      to_be_set = nil
      block_to_execute = Proc.new { to_be_set = 1 }
      Turn.with_table_lock &block_to_execute

      expect(to_be_set).to eq(1)
    end

    it 'executes the block as a transaction' do
      transaction_level = nil
      block_to_execute = Proc.new { transaction_level = Turn.connection.open_transactions }
      Turn.with_table_lock &block_to_execute

      # I don't trust this - returns 1 when no transaction, 2 when there is
      expect(transaction_level).to be > 0
    end

    it 'executes the block with a lock on the Turns table' do
      locked = nil
      block_to_execute = Proc.new { locked = ActiveRecord::Base.connection.execute('select t.relname,l.locktype,page,virtualtransaction,pid,mode,granted from pg_locks l, pg_stat_all_tables t where l.relation=t.relid order by relation asc;').select { |lock| lock['relname'] == 'turns' } }
      Turn.with_table_lock &block_to_execute

      expect(locked.length).to eq(1)
    end
  end
end
