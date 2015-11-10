class StonesController < ApplicationController
  def create
    Stone.create!(row: params[:row], column: params[:column])
  end
end
