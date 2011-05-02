require "deploy"

class Tvrss < ::Deploy::Recipes::PadrinoDataMapper

  class << self

    def link
      super(true)
      link_not_exists("#{config.shared_path}/credentials.rb", ["ln -s #{config.shared_path}/credentials.rb #{config.current_path}/config/credentials.rb"])
      push!
    end

  end

end

