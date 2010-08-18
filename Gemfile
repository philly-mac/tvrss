source :rubygems

# Project requirements
gem 'rake'
gem 'rack-flash'
gem 'thin' # or mongrel

# Component requirements
gem 'haml'
gem 'dm-sqlite-adapter'
gem 'data_mapper'
gem 'nokogiri'

gem 'rack-datamapper-session'

# Testing
group 'test' do
  #unit tests
  gem 'bacon'
  gem "rr"
  gem "rr-matchy"
  gem 'ffaker'
  gem 'machinist', :require => 'machinist/data_mapper'

  #functional tests
  gem 'rack-test'
  gem 'capybara'
end

# Padrino
gem 'padrino', "0.9.14"
