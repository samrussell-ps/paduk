require 'rails_helper'

describe ApplyTurns do
  let(:board) { instance_double(Board) }
  let(:true_service) { Proc.new{ true } }

  before do
    Turn.destroy_all

    @turns = 5.times.map { Turn.create! }
  end

  context 'with no id given' do
    let(:apply_turns) { ApplyTurns.new(board: board) }

    it 'applies all turns' do
      expect(ApplyTurn).to receive(:new).with(@turns[0], board).ordered.and_return(true_service)
      expect(ApplyTurn).to receive(:new).with(@turns[1], board).ordered.and_return(true_service)
      expect(ApplyTurn).to receive(:new).with(@turns[2], board).ordered.and_return(true_service)
      expect(ApplyTurn).to receive(:new).with(@turns[3], board).ordered.and_return(true_service)
      expect(ApplyTurn).to receive(:new).with(@turns[4], board).ordered.and_return(true_service)

      apply_turns.call
    end
  end

  context 'with an id given' do
    let(:apply_turns) { ApplyTurns.new(board: board, turn_id: @turns[2].id) }

    it 'applies turns up to and including the given id' do
      expect(ApplyTurn).to receive(:new).with(@turns[0], board).ordered.and_return(true_service)
      expect(ApplyTurn).to receive(:new).with(@turns[1], board).ordered.and_return(true_service)
      expect(ApplyTurn).to receive(:new).with(@turns[2], board).ordered.and_return(true_service)
      expect(ApplyTurn).to_not receive(:new).with(@turns[3], board)
      expect(ApplyTurn).to_not receive(:new).with(@turns[4], board)

      apply_turns.call
    end
  end
end
