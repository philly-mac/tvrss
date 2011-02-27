require 'deploy'

class TvrssDeploy < Deploy::Recipes::RailsDataMapper

  self.actions << :link_credentials

  def self.link_credentials
    file_path = "#{Deploy::Config.get(:current_path)}/config/credentials.rb"
    file_exists(file_path, [ "rm #{file_path}" ])
    remote "ln -s #{Deploy::Config.get(:shared_path)}/credentials.rb #{Deploy::Config.get(:current_path)}/config/credentials.rb"
  end

end