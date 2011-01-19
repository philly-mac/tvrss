class Padrino < Deploy::Recipes::PadrinoDataMapper

  task :link do
    super(true)
    on_good_exit(file_exists(config.current_path,false), [ "rm #{config.current_path}" ])
    remote "ln -s #{config.shared_path}/credentials.rb #{config.current_path}/config/credentials.rb"
    push!
  end

end

