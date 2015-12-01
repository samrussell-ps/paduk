class ApplyTurns
  def initialize(board:, turn_id: nil)
    @board = board
    @turn_id = turn_id
  end

  # TODO consider immutable board and make more copies
  def call
    turns.each { |turn| ApplyTurn.new(turn, @board).call }

    true
  end

  private

  def turns
    Turn.ordered(@turn_id)
  end
end
