class TurnsController < ApplicationController
  def index
    @next_color = NextColor.new.call

    jump_to_turn
  end

  def create
    jump_to_turn

    create_and_apply_piece(params[:row], params[:column])

    redirect_to turns_url
  end

  def destroy
    redirect_to turns_url
  end

  def show
    jump_to_turn(params[:id])
  end

  private

  # TODO ApplyTurnS service
  def jump_to_turn(turn_id = nil)
    @turns = turns_up_to_id(turn_id)

    @board = Board.new

    @turns.each do |turn|
      ApplyTurn.new(turn, @board).call
    end
  end

  def turns_up_to_id(turn_id = nil)
    turn_id ? Turn.where('id <= ?', params[:id]).order(:id) : Turn.all.order(:id)
  end

  def create_and_apply_piece(row, column)
    next_piece_coordinate = Coordinate.new(row: row.to_i, column: column.to_i) if row && column

    # TODO transaction/lock
    if CreateTurn.new(next_piece_coordinate, @board).call
      ApplyTurn.new(Turn.last, @board).call
    end
  end
end
