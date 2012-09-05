class HomeController < ApplicationController

  include Flight

  respond_to :html, :json

  def index

    @date_from = (DateTime.now >> 1).to_date.strftime('%d/%m/%Y')
    @date_to = ((DateTime.now >> 1).to_date + 3.days).strftime('%d/%m/%Y')
  
  end

  def nice_near

    # TODO XXX refactor into separate helper method for checking params?
    return if params[:location].blank? || params[:weather].blank? || params[:days].blank?

    loc = params[:location].split(',')

    days = params[:days]
    
    weather_type = String.new

    case params[:weather]
    when 'sunny'
      weather_type = 'Clear'
    end

    weather = Weather.range_with_weather(days, days, weather_type).first.observation_location.loc
    @places = Place.near(weather).limit(5)

    respond_with @places do |format|
      format.json { render json: @places }
    end

  end

  def flight_search
    # TODO Move this to somewhere else
    params = { id: 'weathersick', type: 12, url: 'http://www.weathersick.com' }
    booker = Flight::VayamaSearch.new(nil, params)

    @results = booker.search(Flight::VayamaSearch::SEARCH_OW, 'EWR', 'SFO', (DateTime.now >> 1), 1)

    respond_with @results do |format|
      format.json { render json: @results }
    end
  end
end
