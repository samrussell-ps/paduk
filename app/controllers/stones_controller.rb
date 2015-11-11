class StonesController < ApplicationController
  def create
    PlaceStone.new(params[:row], params[:column]).call
  end
end
