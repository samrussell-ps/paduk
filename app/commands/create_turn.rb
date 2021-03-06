require 'set'

class CreateTurn
  def initialize(coordinate, board)
    @coordinate = coordinate
    @board = board
  end

  def call
    Turn.with_table_lock do
      @color = next_color

      validate_move

      create_turn if @errors.empty?
    end
  end

  private

  def validate_move
    valid_move = ValidMove.new(@coordinate, @board)
    valid_move.call
    @errors = valid_move.errors
  end

  def create_turn
    @turn = Turn.create!(color: @color)

    unless pass_turn?
      create_stone_additions

      create_stone_removals
    end

    Turn.last
  end

  def pass_turn?
    @coordinate.nil?
  end

  def create_stone_additions
    @turn.stone_additions.create!(row: @coordinate.row, column: @coordinate.column)
  end

  def create_stone_removals
    stone_removals.each do |coordinate|
      @turn.stone_removals.create!(row: coordinate.row, column: coordinate.column)
    end
  end

  def stone_removals
    VulnerableNeighbors.new(@board, @coordinate, @color).call
  end

  def next_color
    NextColor.new.call
  end
end
