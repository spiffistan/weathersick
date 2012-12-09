class Country
  include MongoMapper::Document

  key :name, String
  key :code, String

end
