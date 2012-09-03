require 'open-uri'
require 'json'
require 'date'
require 'rainbow'

API_KEY = 'eebf95c61da19812'
QUERY   = 'conditions/forecast10day'
API_URL = "http://api.wunderground.com/api/#{API_KEY}"

namespace :db do
  desc "Pull weather data from wunderground.com"
  task :pull_weather => :environment do

    places = []

    (1..50).each do 
      places << Place.all(limit: 1, skip: rand(Place.count())).first
    end

    places.each do |place|

      url = "#{API_URL}/#{QUERY}/q/#{place.loc[0]},#{place.loc[1]}.json"

      result = JSON.parse(open(url).read)

      next if result['response']['error'] 
      next unless result['current_observation']
        
      obs = result['current_observation']
      loc = result['current_observation']['observation_location']
      fc = result['forecast']['simpleforecast']

      puts 'Fetching for ' + obs['station_id']
      
      weather = Weather.find_or_create_by_station_id(obs['station_id'])

      location = ObservationLocation.new

      location.full = loc['full']
      location.city = loc['city']
      location.state = loc['state']
      location.country = loc['country']
      location.country_iso3166 = loc['country_iso3166']
      location.loc = [loc['latitude'].to_f,loc['longitude'].to_f]
      location.elevation = loc['elevation']
      
      weather.observation_location = location
      weather.forecasts.clear

      fc['forecastday'].each do |f|

        forecast  = Forecast.new

        date = DateTime.strptime(f['date']['epoch'].to_s,'%s')

        forecast.date = date
        forecast.conditions = f['conditions']
        forecast.pop = f['.pop']
        forecast.high_c = f['high']['celsius']
        forecast.high_f = f['high']['fahrenheit']
        forecast.low_c = f['low']['celsius']
        forecast.low_f = f['low']['fahrenheit']

        forecast.qpf_day_mm = f['qpf_day']['mm']
        forecast.qpf_day_in = f['qpf_day']['in']
        forecast.qpf_allday_mm = f['qpf_allday']['mm']
        forecast.qpf_allday_in = f['qpf_allday']['in']
        forecast.qpf_night_mm = f['qpf_night']['mm']
        forecast.qpf_night_in = f['qpf_night']['in']

        forecast.snow_day_mm = f['snow_day']['mm']
        forecast.snow_day_in = f['snow_day']['in']
        forecast.snow_allday_mm = f['snow_allday']['mm']
        forecast.snow_allday_in = f['snow_allday']['in']
        forecast.snow_night_mm = f['snow_night']['mm']
        forecast.snow_night_in = f['snow_night']['in']

        forecast.wind_max_kph = f['maxwind']['kph'] 
        forecast.wind_max_mph = f['maxwind']['mph'] 
        forecast.wind_max_dir = f['maxwind']['dir'] 
        forecast.wind_max_degrees = f['maxwind']['degrees'] 

        forecast.wind_ave_kph = f['avewind']['kph'] 
        forecast.wind_ave_mph = f['avewind']['mph'] 
        forecast.wind_ave_dir = f['avewind']['dir'] 
        forecast.wind_ave_degrees = f['avewind']['degrees'] 

        forecast.humidity_ave = f['avehumidity']
        forecast.humidity_min = f['minhumidity']
        forecast.humidity_max = f['maxhumidity']

        weather.forecasts << forecast

      end

      weather.observation_time_rfc822 = obs['observation_time_rfc822']
      weather.local_time_rfc822 = obs['local_time_rfc822']
      weather.weather = obs['weather']
      weather.temp_f = obs['temp_f']
      weather.temp_c = obs['temp_c']
      weather.relative_humidity = obs['relative_humidity']
      weather.precip_today_metric = obs['precip_today_metric']

      weather.save!

      sleep 7 # max 10 queries / minute
    end
  end

  task :pull_planner => :environment do 

    STDOUT.sync = true
    month_names = %w(January Feburary March April May June July August September October November December)

    puts 'Getting historical data from wunderground.com'
      
#    places = []
#
#    (1..50).each do 
#      places << Place.all(limit: 1, skip: rand(Place.count())).first
#    end
    
     airports = Airport.in_use.has_icao.no_historical_weather.all

#    places.each do |place|
    
     airports.each do |airport|

      sleep 7

      # TODO refactor for airports instead of places?

      months = [] 

      puts ">> Finding planner data for #{airport.gps_code}... ".color(:cyan)

#      puts ">> Finding airport for #{place.name}..."

#      url = "#{API_URL}/planner_01010131/q/#{place.loc[0]},#{place.loc[1]}.json"
      url = "#{API_URL}/planner_01010131/q/#{airport.gps_code}.json"
      result = JSON.parse(open(url).read)

      if result['response']['error'] 
        puts 'Error in response, trying next.'.color(:red)
        next
      end

      unless result['trip']
        puts 'Error: no results, trying next.'.color(:red)
        next
      end
      
      icao = result['trip']['airport_code']

      if icao.nil? || icao.empty?
        puts 'Empty airport code, trying next.'.color(:red)
        next
      end

      airport = Airport.find_by_gps_code(icao)

      if airport.nil?
        puts "Error: Airport #{icao} not found in db, trying next.".color(:red)
        next 
      end

      if airport.historical_weather_months.size == 12
        puts "Airport #{airport.gps_code} already populated with data, trying next.".color(:cyan)
        next
      end

      puts "<< Found #{airport.gps_code}.".color(:cyan)


      ## Loop through each month

      (9..11).each do |month| 
        
        sleep 7

        case month
        when 2
          days = 28
        when 1, 3, 5, 7, 8, 10, 12
          days = 31
        else
          days = 30
        end

        range = "%02d%02d%02d%02d" % [month, 1, month, days]

        url = "#{API_URL}/planner_#{range}/q/#{icao}.json"

        print "  Fetching data for #{month_names[month-1]}... "

        result = JSON.parse(open(url).read)

        next if result['response']['error'] 
        next unless result['trip']

        if result['trip']['airport_code'].empty?
          puts
          puts 'Airport code not found, breaking.'.color(:red)
          break
        end
       
        trip = result['trip']

        hist = HistoricalWeather.new

        hist.month = month

        hist.high_min_c = trip['temp_high']['min']['C'].to_i
        hist.high_avg_c = trip['temp_high']['avg']['C'].to_i
        hist.high_max_c = trip['temp_high']['max']['C'].to_i
        hist.high_min_f = trip['temp_high']['min']['F'].to_i
        hist.high_avg_f = trip['temp_high']['avg']['F'].to_i
        hist.high_max_f = trip['temp_high']['max']['F'].to_i

        hist.low_min_c = trip['temp_low']['min']['C'].to_i
        hist.low_avg_c = trip['temp_low']['avg']['C'].to_i
        hist.low_max_c = trip['temp_low']['max']['C'].to_i
        hist.low_min_f = trip['temp_low']['min']['F'].to_i
        hist.low_avg_f = trip['temp_low']['avg']['F'].to_i
        hist.low_max_f = trip['temp_low']['max']['F'].to_i
        
        hist.dewpoint_high_min_c = trip['dewpoint_high']['min']['C'].to_i
        hist.dewpoint_high_avg_c = trip['dewpoint_high']['avg']['C'].to_i
        hist.dewpoint_high_max_c = trip['dewpoint_high']['max']['C'].to_i
        hist.dewpoint_high_min_f = trip['dewpoint_high']['min']['F'].to_i
        hist.dewpoint_high_avg_f = trip['dewpoint_high']['avg']['F'].to_i
        hist.dewpoint_high_max_f = trip['dewpoint_high']['max']['F'].to_i
        
        hist.dewpoint_low_min_c = trip['dewpoint_low']['min']['C'].to_i
        hist.dewpoint_low_avg_c = trip['dewpoint_low']['avg']['C'].to_i
        hist.dewpoint_low_max_c = trip['dewpoint_low']['max']['C'].to_i
        hist.dewpoint_low_min_f = trip['dewpoint_low']['min']['F'].to_i
        hist.dewpoint_low_avg_f = trip['dewpoint_low']['avg']['F'].to_i
        hist.dewpoint_low_max_f = trip['dewpoint_low']['max']['F'].to_i

        hist.precip_min_cm = trip['precip']['min']['cm'].to_f
        hist.precip_avg_cm = trip['precip']['avg']['cm'].to_f
        hist.precip_max_cm = trip['precip']['max']['cm'].to_f
        hist.precip_min_in = trip['precip']['min']['in'].to_f
        hist.precip_avg_in = trip['precip']['avg']['in'].to_f
        hist.precip_max_in = trip['precip']['max']['in'].to_f

        chance = trip['chance_of']

        hist.chance_temp_below_0      = chance['tempbelowfreezing']['percentage'].to_i
        hist.chance_temp_0_16         = chance['tempoverfreezing']['percentage'].to_i
        hist.chance_temp_16_32        = chance['tempoversixty']['percentage'].to_i
        hist.chance_temp_over_32      = chance['tempoverninety']['percentage'].to_i
        hist.chance_dewpoint_over_16  = chance['chanceofhumidday']['percentage'].to_i
        hist.chance_dewpoint_over_21  = chance['chanceofsultryday']['percentage'].to_i
        hist.chance_precip            = chance['chanceofprecip']['percentage'].to_i
        hist.chance_snow_ground       = chance['chanceofsnowonground']['percentage'].to_i
        hist.chance_rain_day          = chance['chanceofrainday']['percentage'].to_i
        hist.chance_snow_day          = chance['chanceofsnowday']['percentage'].to_i
        hist.chance_hail_day          = chance['chanceofhailday']['percentage'].to_i
        hist.chance_partly_cloudy_day = chance['chanceofpartlycloudyday']['percentage'].to_i
        hist.chance_cloudy_day        = chance['chanceofcloudyday']['percentage'].to_i
        hist.chance_foggy_day         = chance['chanceofhailday']['percentage'].to_i
        hist.chance_thunder_day       = chance['chanceofthunderday']['percentage'].to_i
        hist.chance_tornado_day       = chance['chanceoftornadoday']['percentage'].to_i
        hist.chance_windy_day         = chance['chanceofwindyday']['percentage'].to_i
        hist.chance_sunny_cloudy_day  = chance['chanceofsunnycloudyday']['percentage'].to_i

        months << hist

        puts "done".color(:green)

      end

      airport.historical_weather_months = months
        
      airport.save!

      puts "Saved historical data for #{airport.gps_code}".color(:cyan)
      puts 

    end
  end
end
