Dir["#{Rails.root}/db/seeds/*.rb"].each {|file| require file }

Seeds::Users.load
