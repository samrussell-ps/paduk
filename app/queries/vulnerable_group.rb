class VulnerableGroup
  def initialize(board, coordinate)
    @board = board
    @coordinate = coordinate
  end

  def call
    LibertiesCount.new(@board, @coordinate).call == 1
  end
end
