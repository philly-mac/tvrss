require 'whiskey_disk/helpers'

rails_env = RAILS_ENV = ENV['RAILS_ENV'] if ENV['RAILS_ENV'] and ENV['RAILS_ENV'] != ''
user      = ENV['DEPLOY_USER']
group     = ENV['DEPLOY_GROUP']
dir       = ENV['DEPLOY_DIR']
root      = "/var/www/#{dir}"

namespace :deploy do
  task :post_setup  => [ :create_rails_directories ]

  task :post_deploy do
    Rake::Task['deploy:fix_permissions'].invoke
    Rake::Task['assets:precompile'].invoke if changed?('app/assets')
    Rake::Task['db:migrate'].invoke        if changed?('db/migrate')
  end

  task :create_rails_directories do
    Dir.chdir(root)
    system("mkdir -p log tmp public/uploads")
  end

  task :fix_permissions do
    if !user.blank? && !group.blank? && !dir.blank?
      system "sudo chown -Rf #{user}:#{group} /var/www/#{dir}"
      system "sudo find /var/www/#{dir} -type d -exec chmod 775 '{}' \\;"
      system "sudo find /var/www/#{dir} -type f -exec chmod 664 '{}' \\;"
      system "sudo chmod 775 /var/www/#{dir}/bin/*"
    end
  end

  namespace :unicorn do
    %w[start stop restart].each do |command|
      desc "#{command} unicorn server"
      task command do
        system "sudo /etc/init.d/unicorn_init_#{composite_name} #{command}"
      end
    end

    desc "Setup unicorn config for nginx and as an init file"
    task :setup_config do
      sudo "ln -nfs #{current_path}/config/deploy/nginx/unicorn_nginx_#{composite_name} /etc/nginx/sites-enabled/"
      sudo "ln -nfs #{current_path}/config/deploy/unicorn/unicorn_init_#{composite_name} /etc/init.d/"
    end

    desc "Create nginx conf file"
    task :create_config_ngin do
      template = "#{File.dirname(__FILE__)}/deploy/templates/nginx/unicorn_nginx.erb"
      filename = "#{File.dirname(__FILE__)}/deploy/nginx/unicorn_nginx_#{composite_name}"
      options  = {
        :composite_name => composite_name,
        :server_name    => server_name,
      }

      create_conf_file(template, filename, options)
    end

    desc "Create unicorn conf file"
    task :create_config_unicorn do
      template = "#{File.dirname(__FILE__)}/deploy/templates/unicorn/unicorn_conf.erb"
      filename = "#{File.dirname(__FILE__)}/deploy/unicorn/unicorn_conf_#{composite_name}.rb"
      options  = {
        :composite_name => composite_name,
        :app_root       => current_path,
      }

      create_conf_file(template, filename, options)
    end

    desc "Create init script file"
    task :create_config_unicorn_init do
      template = "#{File.dirname(__FILE__)}/deploy/templates/unicorn/unicorn_init.erb"
      filename = "#{File.dirname(__FILE__)}/deploy/unicorn/unicorn_init_#{composite_name}"
      options  = {
        :composite_name => composite_name,
        :app_root       => current_path,
        :app_user       => group,
        :app_env        => rails_env,
      }

      create_conf_file(template, filename, options)
      system "chmod 775 #{filename}"
    end

  end

end

def composite_name
 "#{application}-#{rails_env}"
end

def create_conf_file(template, output, options)
  require 'erubis'

  nginx_conf     = File.read(template)
  nginx_erb_conf = Erubis::Eruby.new(nginx_conf)

  filename = output

  File.open(output, 'w') do |file|
    file.write(nginx_erb_conf.result(options))
  end
end
