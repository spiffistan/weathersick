require 'open-uri'

class HomeController < ApplicationController

  include Flight

  respond_to :html, :json

  def index

    @date_from = (DateTime.now >> 1).to_date.strftime('%d/%m/%Y')
    @date_to = ((DateTime.now >> 1).to_date + 3.days).strftime('%d/%m/%Y')
  
  end
2
  def nice_weather

    range = (48..49) # (params[:range_start].to_i..params[:range_end].to_i)

    q = { 
      "$and" => [ 
        chance_partly_or_sunny: { "$gte" => 80 }, 
        chance_hightemp: { "$gte" => 80 }, 
        chance_crappy: { "$lte" => 20 }, 
        week: { "$in" => range.to_a } 
      ]
    }

    list = HistoricalWeather.where(q).fields(
      station:1,chance_partly_or_sunny:1,chance_hightemp:1,chance_shitty:1,high_avg_c:1,week:1
    ).all
    stations = list.collect {|it| it.station }
    good = stations.select { |it| stations.count(it) == range.to_a.size }.uniq
    cities = City.where({ "$and" => [wstation_code: {"$in" => good}]}).sort(city_rank:-1).all.take(5).to_ary
    
    cities.each do |city|
      city.weather = []
      w = list.select { |element| element.station == city.wstation_code }
      w.each do |we|
        city.weather.push(we)
      end
    end
    
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
