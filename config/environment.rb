# Load the rails application
require File.expand_path('../application', __FILE__)

SimpleAuth::Config.library = :sequel

Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.plugin(:timestamps, :force => true, :update_on_create => true)

# Initialize the rails application
Tvrss::Application.initialize!
