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
