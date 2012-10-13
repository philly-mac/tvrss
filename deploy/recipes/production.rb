recipe :rails_data_mapper

desc 'deploy', 'deploys optomlocum without changing anything in the database', true do
  queue [
    :set_prev_release_tag,
    :set_release_tag,
    :create_release_dir,
    :link,
    :pull_code,
    :bundle,
    :clean_up,
    :link_credentials,
    :restart
  ]
  process_queue
end

desc 'deploy_with_migrations', 'deploys any database upgrade migrations', true do
  queue [
    :set_prev_release_tag,
    :set_release_tag,
    :create_release_dir,
    :link,
    :pull_code,
    :bundle,
    :auto_upgrade,
    :clean_up,
    :link_credentials,
    :restart
  ]
  process_queue
end

desc "link_credentials", "Links customs credentials file" do
  file_path = "#{dep_config.get(:current_path)}/config/credentials.rb"
  file_exists(file_path, [ "rm #{file_path}" ])
  remote "ln -s #{dep_config.get(:shared_path)}/credentials.rb #{dep_config.get(:current_path)}/config/credentials.rb"
end
