class AirportsController < ApplicationController

  respond_to :html, :json

  def index
    @airports = Airport.limit(10)

    respond_with @airports
  end

  def show
    @airport = Airport.where(id: params[:id].to_i).first

    respond_with @airport
  end

  def near
    @airports = Airport.near(params[:location].split(',')).limit(10)

    respond_with @airports
  end

  def search
    @airports = Airport.search_name_iata(params[:query]).limit(10)

    respond_with @airports
  end

  def typeahead
    @airports = Airport.search_name_iata(params[:query]).limit(10).all.collect! {|airport| airport.name }

    respond_with @airports
  end
end
