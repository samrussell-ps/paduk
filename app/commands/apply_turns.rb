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
    if @turn_id
      # TODO ask turn about this, SQL should not be here
      # the message is for Turn, not this
      Turn.where('id <= ?', @turn_id).order(:id)
    else
      Turn.all.order(:id)
    end
  end
end
