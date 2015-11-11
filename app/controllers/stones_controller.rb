class StonesController < ApplicationController
  OTHER_COLOR = { 'black' => 'white',
    'white' => 'black'
  }
  def create
    Stone.transaction do
      PlaceStone.new(params[:row], params[:column]).call

      RemoveSurroundedStones.new(OTHER_COLOR[Stone.last.color]).call
    end

    redirect_to stones_url
  end

  def index
    @stones = Stone.all
  end

  def new
  end

  def destroy
    Stone.find(params[:id]).destroy!

    redirect_to stones_url
  end
end
