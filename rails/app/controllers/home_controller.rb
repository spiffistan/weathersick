require 'open-uri'

class HomeController < ApplicationController

  include Flight

  respond_to :html, :json

  def index

    @date_from = (DateTime.now >> 1).to_date.strftime('%d/%m/%Y')
    @date_to = ((DateTime.now >> 1).to_date + 3.days).strftime('%d/%m/%Y')
  
  end

  def nice_weather

    range = (17..18) # (params[:range_start].to_i..params[:range_end].to_i)

    q = { 
      "$and" => [ 
         chance_sunny_cloudy_day: { "$gte" => 20 }, 
         "$or" => [
           chance_temp_16_32: { "$gte" => 25 }, 
           chance_temp_over_32: { "$gte" => 15 }
         ],
         week: { "$in" => range.to_a } 
      ]
    }

    list = HistoricalWeather.where(q).all.collect {|it| it.station }
    good = list.select { |it| list.count(it) == range.to_a.size }.uniq
    cities = City.where({ "$and" => [wstation_code: {"$in" => good}, city_rank: { "$gt" => 300 }]}).all.sample(5)

    respond_with cities
  end

  def flight_search
    # TODO Move this to somewhere else
#    params = { id: 'weathersick', type: 12, url: 'http://www.weathersick.com' }
#    booker = Flight::VayamaSearch.new(nil, params)
#
#    @results = booker.search(Flight::VayamaSearch::SEARCH_OW, 'EWR', 'SFO', (DateTime.now >> 1), 1)
#
#    respond_with @results do |format|
#      format.json { render json: @results }
#    end
    # Development:
   respond_to do |format|
     format.json  { 
       render json: open('http://localhost:3000/flight.json').read
     }
   end
  end
end
