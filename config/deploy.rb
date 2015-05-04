# require "rvm/capistrano"
# require "bundler/capistrano"
# require 'capistrano/bundler'

# config valid only for current version of Capistrano
lock '3.0.1'

set :application, 'demo'
set :repo_url, 'https://github.com/akashbachhania/demo.git'
set :user, 'ubuntu'

set :scm, :git
#call with cap -S env="<env>" branch="<branchname>" deploy
# set :bundle_env_variables, { 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 1 }
# set :keep_releases, 10
# set :branch, "staging"
# set :rails_env, "production"
# set :user, :deploy
# set :use_sudo, false
# set :ssh_options, { :forward_agent => true }
# set :deploy_to, "/home/ubuntu/#{application}"
# default_run_options[:pty] = true
# set :normalize_asset_timestamps, false
# set :rvm_type, :system
# set :unicorn_binary, "/usr/local/rvm/gems/ruby-1.9.3-p448/bin/unicorn"
# set :unicorn_config, "#{current_path}/config/unicorn.rb"
# set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

# role :web, "107.20.204.18"                          # Your HTTP server, Apache/etc
# role :app, "107.20.204.18"                          # This may be the same as your `Web` server
# role :db,  "107.20.204.18", :primary => true # This is where Rails migrations will run

# #before "deploy:assets:precompile", "deploy:symlinks"
# #after 'deploy:update_code', 'deploy:symlinks'
# #after 'deploy:update_code', 'deploy:run_migrations'
#after 'deploy:create_symlink', 'deploy:restart'

# namespace :deploy do
#   namespace :assets do
#     #task :precompile do
#     #  puts "Doing nothing"
#     #end
#   end

#  desc "Create symlnks for database.yaml and environments files"
#   task :symlinks do
#     run "rm -f #{release_path}/config/database.yml"
#     run "rm -f #{release_path}/config/unicorn.rb"
#     run "rm -rf #{release_path}/log"
#     #run "rm -rf #{release_path}/tmp/pids"

#     run "ln -nfs #{shared_path}/log/ #{release_path}/log"
#     #run "ln -nfs #{shared_path}/tmp/pids #{release_path}/tmp/pids"
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#     run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
#   end


#   #task :run_migrations, :roles => :db do
#     #puts "RUNNING DB MIGRATIONS"
#     #run "cd #{current_path}; rake db:migrate RAILS_ENV=#{rails_env}"
#   #end

#   task :start, :roles => :app, :except => { :no_release => true } do
#     run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
#   end
#   task :stop, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} kill `cat #{unicorn_pid}`"
#   end
#   task :graceful_stop, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
#   end
#   task :reload, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
#   end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     stop
#     start
#   end
# end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
set :pty, true

set :keep_releases, 1

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
       #execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'


end