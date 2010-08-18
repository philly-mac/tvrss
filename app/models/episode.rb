class Episode
  include DataMapper::Resource

  property :id,             Serial
  property :episode,        Integer
  property :season,         Integer
  property :product_number, String
  property :air_date,       Date
  property :url,            Text
  property :title,          String
end
