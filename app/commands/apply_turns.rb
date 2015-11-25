class ApplyTurns
  def initialize(board:, turn_id: nil)
    @board = board
    @turn_id = turn_id
  end

  def call
    turns.each { |turn| ApplyTurn.new(turn, @board).call }
  end

  private

  def turns
    if @turn_id
      Turn.where('id <= ?', @turn_id).order(:id)
    else
      Turn.all.order(:id)
    end
  end
end
