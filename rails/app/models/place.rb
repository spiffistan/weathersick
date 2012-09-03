class Place
  include MongoMapper::Document

  key :country_code, String
  key :name, String
  key :asciiname, String
  key :population, Integer
  key :elevation, Integer
  key :modification_date, String
  key :timezone, String

  key :loc, Array

  ensure_index [[:loc, '2d']]

  def self.nearest(location)
    where(loc: {"$near" => location}).limit(1).first
  end

  def self.near(location)
    where(loc: {"$near" => location})
  end
end
