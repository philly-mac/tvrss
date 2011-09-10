require 'deploy'
require 'deploy/recipes/rails_data_mapper'

class TvrssDeploy < ::Deploy::Recipes::RailsDataMapper

  append  :link_credentials

  desc "link_credentials", "Links customs credentials file" do
    file_path = "#{Deploy::Config.get(:current_path)}/config/credentials.rb"
    file_exists(file_path, [ "rm #{file_path}" ])
    remote "ln -s #{Deploy::Config.get(:shared_path)}/credentials.rb #{Deploy::Config.get(:current_path)}/config/credentials.rb"
  end

end