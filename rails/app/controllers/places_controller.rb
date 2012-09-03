class PlacesController < ApplicationController

  respond_to :html, :json

  def near
    @place = Place.near(params[:location].split(',')).limit(10).first

    respond_with @place
  end
end
