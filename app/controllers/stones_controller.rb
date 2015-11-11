class StonesController < ApplicationController
  def create
    PlaceStone.new(params[:row], params[:column]).call

    redirect_to stones_url
  end

  def index
    @stones = Stone.all
  end

  def new
  end
end
