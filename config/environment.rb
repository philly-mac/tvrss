# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tvrss::Application.initialize!

if Rails.env.development?
  Sass::Plugin.options[:style] = :expanded
else
  Sass::Plugin.options[:style] = :compact
end

Sass::Plugin.options[:template_location] = "#{Rails.root}/app/stylesheets"
