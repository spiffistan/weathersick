class HistoricalWeather

  include MongoMapper::Document
  
  key :station, String

  key :month, Integer

  key :loc, Array
  key :sphereloc, Array
  
  ensure_index [[:sphereloc, '2d']]
  
  key :cloud_cover, String # Good: "mostly sunny", "sunny", "cloudy"

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
  
  key :chance_partly_or_sunny, Integer
  key :chance_hightemp, Integer
  key :chance_crappy, Integer
end

