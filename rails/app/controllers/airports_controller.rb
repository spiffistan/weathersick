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
    @airports = Airport.search_name_iata(params[:query]).limit(10).all.collect! do |airport| 
      { name: airport.name, id: airport.iata_code } 
    end

    respond_to do |format|
      format.json{ render :json => @airports.to_json }
    end
  end
end
