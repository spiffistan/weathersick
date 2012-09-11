class WeatherStation
  include MongoMapper::Document

  key :station_id, String
  key :observation_time_rfc822, String
  key :local_time_rfc822, String
  key :weather, String
  key :temp_f, Integer
  key :temp_c, Integer
  key :relative_humidity, String
  key :precip_today_metric, String

  many :forecasts

  one :observation_location

  timestamps!

  def self.nearest(location)
    where(loc: {"$near" => location}).limit(1).first
  end

  def self.near(location)
    where(loc: {"$near" => location})
  end

  def self.range_with_weather(from, to, weather)

    conditions = []

    (from..to).each do |i|
      conditions << { "forecasts.#{i}.conditions" => weather }
    end

    where("$and" => conditions)
  end
end

class Forecast
  include MongoMapper::EmbeddedDocument

  key :date, String

  key :conditions, String
  key :pop, Integer
  
  key :high_c, Float
  key :high_f, Float
  
  key :low_c, Float
  key :low_f, Float
  
  key :qpf_day_mm, Float
  key :qpf_day_in, Float
  key :qpf_allday_mm, Float
  key :qpf_allday_in, Float
  key :qpf_night_mm, Float
  key :qpf_night_in, Float
  
  key :snow_day_mm, Float
  key :snow_day_in, Float
  key :snow_allday_mm, Float
  key :snow_allday_in, Float
  key :snow_night_mm, Float
  key :snow_night_in, Float

  key :wind_ave_kph, Float
  key :wind_ave_mph, Float
  key :wind_ave_dir, String
  key :wind_ave_degrees, Integer
  
  key :wind_max_kph, Float
  key :wind_max_mph, Float
  key :wind_max_dir, String
  key :wind_max_degrees, Integer

  key :humidity_ave, Integer
  key :humidity_max, Integer
  key :humidity_min, Integer
  
end


class ObservationLocation
  include MongoMapper::EmbeddedDocument

  key :full, String
  key :city, String
  key :state, String
  key :country, String
  key :country_iso3166, String
  key :loc, Array
  key :elevation, String
end
