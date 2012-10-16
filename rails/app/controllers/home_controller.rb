require 'open-uri'
require 'geokit'
require 'json'

class HomeController < ApplicationController

  DATE_FORMAT = '%d/%m/%Y'
  NUM_RESULTS = 3

  include Flight

  respond_to :html, :json

  def index

    @date_from = (DateTime.now.next_week.next_day(5)).to_date.strftime(DATE_FORMAT)
    @date_to = (DateTime.now.next_week.next_day(7)).to_date.strftime(DATE_FORMAT)

    # geoloc = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    geoloc = Geokit::Geocoders::MultiGeocoder.geocode('84.48.215.199') # XXX Dummy working ip

    latlng = [geoloc.lat,geoloc.lng]

    @airport = Airport.nearest(latlng)

  end

  def nice_weather

    duration = 7 # XXX dummy
    num_people = 1 # dummy
   
    from_iata = params[:from]
    date_from = DateTime.strptime(params[:date_from], DATE_FORMAT)
    date_to = DateTime.strptime(params[:date_to], DATE_FORMAT)
    range = ((date_from.cweek + 1)..(date_to.cweek + 1)) # cweek starts with 0

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
      high_avg_f:1,
      week:1
    ).all

    stations = list.collect { |it| it.station }
    good = stations.select { |it| stations.count(it) == range.to_a.size }.uniq
    cities = City.where({ "$and" => [wstation_code: {"$in" => good}]}).sort(city_rank:-1).limit(30).all.shuffle!.take(NUM_RESULTS)
    
    cities.each do |city|
      city.weather = []
      w = list.select { |element| element.station == city.wstation_code }
      city.weather << w[0]
      #w = list.select { |element| element.station == city.wstation_code }
      #w.each do |we|
      #  city.weather["week" + we.week.to_i.to_s] = we
      #end
    end

    # TODO Move this to somewhere else
    booker_params = { id: 'weathersick', type: 12, url: 'http://www.weathersick.com' }
    booker = Flight::VayamaSearch.new(nil, booker_params)

    destinations = []

    cities.each do |city|
      destination = JSON.parse(city.to_json) # convert to hash since we need to edit the objects. XXX SNOOF SNOOF UGLY WE DO NOT WANT THIS XXX
      airport = Airport.nearest(city.loc)
      results = booker.search(Flight::VayamaSearch::SEARCH_OW, from_iata, airport.iata_code, date_from, num_people)
      unless(results.empty?)
        destination[:total_fare] = results[0][:total_fare]
        destination[:booking_link] = results[0][:booking_link]
        destinations << destination
      end
    end

    respond_with destinations

  end
end
