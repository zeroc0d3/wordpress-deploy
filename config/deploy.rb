# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "wordpress-deploy"
set :repo_url, "git@github.com:zeroc0d3/wordpress-deploy.git"

set :branch,    "master"
set :deploy_to, "/home/deploy/wordpress-deploy"
set :tmp_dir,   "/home/deploy/tmp"

append :linked_files, "wp-config.php"

set :pty, true

set :keep_releases, 5

namespace :deploy do
  desc 'Restart Deploy'
  task :restart do
    on roles(:web) do
      if test("[ -d #{ current_path }/wp-content/files_mf ]")
        execute "chmod 777 -R #{ current_path }/wp-content/files_mf"
      else
        info "Can't find: wp-content/files_mf folder !"
      end
    end
  end

  desc 'Reload NGINX'
  task :nginx_reload do
    on roles(:all) do
      sudo :service, :nginx, :reload
    end
  end

  desc 'Restart NGINX'
  task :nginx_restart do
    on roles(:web), in: :sequence do
      execute! :sudo, :service, :nginx, :restart
    end
  end

  desc 'Reload PHP-FPM'
  task :phpfpm_reload do
    on roles(:all) do
      sudo :service, :'php7.0-fpm', :reload
    end
  end

  desc 'Restart PHP-FPM'
  task :phpfpm_restart do
    on roles(:web), in: :sequence do
      execute! :sudo, :service, :'php7.0-fpm', :restart
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
after 'deploy:restart', 'deploy:nginx_reload'
after 'deploy:restart', 'deploy:nginx_restart'
after 'deploy:restart', 'deploy:phpfpm_reload'
after 'deploy:restart', 'deploy:phpfpm_restart'