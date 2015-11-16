class TurnsController < ApplicationController
  def index
    @turns = Turn.all
  end

  def create
    CreateTurn.new(Coordinate.new(row: params[:row].to_i, column: params[:column].to_i)).call

    redirect_to turns_url
  end

  def destroy
    redirect_to turns_url
  end
end
