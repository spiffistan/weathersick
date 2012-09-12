class City
  include MongoMapper::Document

  key :city_name, String
  key :province_name, String
  key :country_name, String
  key :wstation_code, String

  key :city_rank, Float

  key :loc, Array
  key :sphereloc, Array

  ensure_index [[:sphereloc, '2d']]

  def self.nearest(location)
    where(loc: {"$near" => location}).limit(1).first
  end

  def self.near(location)
    where(loc: {"$near" => location})
  end
end
