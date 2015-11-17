class TurnsController < ApplicationController
  def index
    @next_color = NextColor.new.call

    jump_to_turn
  end

  def create
    jump_to_turn

    next_piece_coordinate = Coordinate.new(row: params[:row].to_i, column: params[:column].to_i)

    if CreateTurn.new(next_piece_coordinate, @board).call
      ApplyTurn.new(Turn.last, @board).call
    end

    redirect_to turns_url
  end

  def destroy
    redirect_to turns_url
  end

  def show
    puts params[:id]
    @turns = Turn.where('id <= ?', params[:id])
  end

  private

  def jump_to_turn(turn_id = nil)
    @turns = turn_id ? Turn.where('id <= ?', params[:id]).order(:id) : Turn.all.order(:id)
    @board = Board.new

    Turn.all.each do |turn|
      ApplyTurn.new(turn, @board).call
    end
  end
end
