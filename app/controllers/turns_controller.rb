class TurnsController < ApplicationController
  def index
    @turns = Turn.all
  end

  def create
    board = Board.new
    # needs to be in order
    Turn.all.each do |turn|
      ApplyTurn.new(turn, board).call
    end
    CreateTurn.new(Coordinate.new(row: params[:row].to_i, column: params[:column].to_i), board).call

    ApplyTurn.new(Turn.last, board).call

    redirect_to turns_url
  end

  def destroy
    redirect_to turns_url
  end

  def show
    puts params[:id]
    @turns = Turn.where('id <= ?', params[:id])
  end
end
