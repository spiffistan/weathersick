class Airport

  include MongoMapper::Document

  key :continent, String
  key :elevation, Integer, default: 0
  key :loc, Array
  key :gps_code, String
  key :home_link, String
  key :iata_code, String
  key :ident, String
  key :iso_country, String
  key :iso_region, String
  key :keywords, String
  key :local_code, String
  key :municipality, String
  key :name, String
  key :scheduled_service, String
  key :type, String
  key :wikipedia_link, String
  key :in_use, Boolean

  many :historical_weather_months, 
       :class_name => 'HistoricalWeather'

  ensure_index [[:loc, '2d']]

  class << self
    def nearest(location)
      where(loc: {"$near" => location}).limit(1).first
    end

    def near(location)
      where(loc: {"$near" => location})
    end

    def has_iata
      where({iata_code: {"$ne" => "" }})
    end
    
    def has_icao
      where({gps_code: {"$ne" => "" }})
    end

    def is_serviced
      where(scheduled_service: "yes")
    end

    def in_use
      where(in_use: true)
    end

    def search_name_iata(text)
      regex = /.*#{text}.*/i

      where({"$or" => [{name: regex}, {iata_code: regex}]})
    end

    def has_historical_weather
      where(historical_weather_months: { "$exists" => true })
    end
    
    def no_historical_weather
      where(historical_weather_months: { "$exists" => false })
    end
  end
end

class HistoricalWeather

  include MongoMapper::EmbeddedDocument

  key :month, Integer

  # one :high_min, class_name: 'Temperature'
  # one :high_avg, class_name: 'Temperature'
  # one :high_max, class_name: 'Temperature'
  # one :low_min,  class_name: 'Temperature'
  # one :low_avg,  class_name: 'Temperature'
  # one :low_max,  class_name: 'Temperature'

  # one :precip_min, class_name: 'Precipitation'
  # one :precip_avg, class_name: 'Precipitation'
  # one :precip_max, class_name: 'Precipitation'

  # one :dewpoint_high_min, class_name: 'Temperature'
  # one :dewpoint_high_avg, class_name: 'Temperature'
  # one :dewpoint_high_max, class_name: 'Temperature'
  # one :dewpoint_low_min,  class_name: 'Temperature'
  # one :dewpoint_low_avg,  class_name: 'Temperature'
  # one :dewpoint_low_max,  class_name: 'Temperature'

  key :high_min_c, Integer
  key :high_avg_c, Integer
  key :high_max_c, Integer
  key :high_min_f, Integer
  key :high_avg_f, Integer
  key :high_max_f, Integer
  
  key :low_min_c, Integer
  key :low_avg_c, Integer
  key :low_max_c, Integer
  key :low_min_f, Integer
  key :low_avg_f, Integer
  key :low_max_f, Integer

  key :precip_min_cm, Float
  key :precip_avg_cm, Float
  key :precip_max_cm, Float
  key :precip_min_in, Float
  key :precip_avg_in, Float
  key :precip_max_in, Float

  key :dewpoint_high_min_c, Integer
  key :dewpoint_high_min_f, Integer
  key :dewpoint_high_avg_c, Integer
  key :dewpoint_high_avg_f, Integer
  key :dewpoint_high_max_c, Integer
  key :dewpoint_high_max_f, Integer

  key :dewpoint_low_min_c, Integer
  key :dewpoint_low_min_f, Integer
  key :dewpoint_low_avg_c, Integer
  key :dewpoint_low_avg_f, Integer
  key :dewpoint_low_max_c, Integer
  key :dewpoint_low_max_f, Integer

  key :chance_temp_below_0, Integer
  key :chance_temp_0_16, Integer
  key :chance_temp_16_32, Integer
  key :chance_temp_over_32, Integer
  key :chance_dewpoint_over_16, Integer
  key :chance_dewpoint_over_21, Integer
  key :chance_precip, Integer
  key :chance_snow_ground, Integer
  key :chance_rain_day, Integer
  key :chance_snow_day, Integer
  key :chance_hail_day, Integer
  key :chance_partly_cloudy_day, Integer
  key :chance_cloudy_day, Integer
  key :chance_foggy_day, Integer
  key :chance_thunder_day, Integer
  key :chance_tornado_day, Integer
  key :chance_windy_day, Integer
  key :chance_sunny_cloudy_day, Integer

end

# class Temperature
#   include MongoMapper::EmbeddedDocument
#   key :c, Integer
#   key :f, Integer
# end
# 
# class Precipitation
#   include MongoMapper::EmbeddedDocument
#   key :cm, Float
#   key :in, Float
# end
