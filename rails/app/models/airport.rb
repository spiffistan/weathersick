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

  end
end
