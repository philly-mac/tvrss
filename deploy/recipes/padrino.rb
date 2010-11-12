class Padrino < Deploy::Recipes::Padrino

  class << self

    def link
      super(true)
      on_good_exit(file_exists(config.current_path,false), [ "rm #{config.current_path}" ])
      remote "ln -s #{config.shared_path}/credentials.rb #{config.current_path}/config/credentials.rb"
      push!
    end

  end

end

