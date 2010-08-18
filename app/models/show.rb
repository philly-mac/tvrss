class Show
  include DataMapper::Resource

  property :id,      Serial
  property :show_id, String
  property :name,    String
  property :url,     String
end
