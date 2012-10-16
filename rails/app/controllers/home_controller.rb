require 'open-uri'
require 'geokit'

class HomeController < ApplicationController

  DATE_FORMAT = '%d/%m/%Y'
  NUM_RESULTS = 3

  include Flight

  respond_to :html, :json

  def index
<<<<<<< HEAD

  @date_from = (DateTime.now.next_week.next_day(5)).to_date.strftime(DATE_FORMAT)
  @date_to = (DateTime.now.next_week.next_day(7)).to_date.strftime(DATE_FORMAT)
=======
    
    @date_from = (DateTime.now.next_week.next_day(5-1)).to_date.strftime('%d/%m/%Y')
    @date_to = (DateTime.now.next_week.next_day(7-1)).to_date.strftime('%d/%m/%Y')
>>>>>>> aa3480919007ff24b529b10bbf23f180b749085b

    # geoloc = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    geoloc = Geokit::Geocoders::MultiGeocoder.geocode('84.48.215.199') # XXX Dummy working ip

    latlng = [geoloc.lat,geoloc.lng]

    @airport = Airport.nearest(latlng)

  end

  def nice_weather

    #range = (48..49) # (params[:range_start].to_i..params[:range_end].to_i)
    
    if(params[:date_from] && params[:date_to]) # TODO more sanity checks
      from = Date.strptime(params[:date_from], DATE_FORMAT)
      to = Date.strptime(params[:date_to], DATE_FORMAT)
      range = (from.cweek..to.cweek)
      puts range
    end

    q = { 
      "$and" => [ 
        chance_partly_or_sunny: { "$gte" => 80 }, 
        chance_hightemp: { "$gte" => 80 }, 
        chance_crappy: { "$lte" => 20 }, 
        week: { "$in" => range.to_a } 
      ]
    }

    list = HistoricalWeather.where(q).fields(
      station:1,
      chance_partly_or_sunny:1,
      chance_hightemp:1,
      chance_crappy:1,
      high_avg_c:1,
      week:1
    ).all

    stations = list.collect { |it| it.station }
    good = stations.select { |it| stations.count(it) == range.to_a.size }.uniq
    cities = City.where({ "$and" => [wstation_code: {"$in" => good}]}).sort(city_rank:-1).limit(NUM_RESULTS).all
    
    cities.each do |city|
      city.weather = []
      w = list.select { |element| element.station == city.wstation_code }
      city.weather << w[0]
      #w = list.select { |element| element.station == city.wstation_code }
      #w.each do |we|
      #  city.weather["week" + we.week.to_i.to_s] = we
      #end
    end

    puts cities.inspect

    respond_with cities
  end

  def flight_search

    # TODO Move this to somewhere else
    booker_params = { id: 'weathersick', type: 12, url: 'http://www.weathersick.com' }
    booker = Flight::VayamaSearch.new(nil, params)

    if(params[:date_from] && params[:date_to]) # TODO more sanity checks
      from = Date.strptime(params[:date_from], DATE_FORMAT)
      to = Date.strptime(params[:date_to], DATE_FORMAT)
      cities = nice_weather((from.cweek..to.cweek))
    end

    airports = []

    cities.each do |city|
      airports << Airport.nearest(city.loc)
    end

    puts airports

#    if(params[:from])
#      @results = booker.search(Flight::VayamaSearch::SEARCH_OW, 'EWR', 'SFO', (DateTime.now >> 1), 1)
#    end
#
#    respond_with @results do |format|
#      format.json { render json: @results }
#    end
    # Development:
#   respond_to do |format|
#     format.json  { 
#       render json: open('http://localhost:3000/flight.json').read
#     }
#   end
  end
end
