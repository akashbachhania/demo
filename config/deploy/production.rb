# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
set :stage, :production
set :rails_env, 'production'
set :application, 'demo'
set :server_address, "52.24.70.229"

role :app, %W{ubuntu@#{fetch(:server_address)}}
role :web, %W{ubuntu@#{fetch(:server_address)}}
role :db,  %W{ubuntu@#{fetch(:server_address)}}

set :user, 'ubuntu'
# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server fetch(:server_address), user: 'ubuntu', roles: %w{web app db}
set :ssh_options, user: 'ubuntu', forward_agent: true
set :deploy_to, "/home/ubuntu/apps/#{fetch(:application)}"

set :unicorn_env, "production"
set :unicorn_rack_env, "production"
set :unicorn_bin, "unicorn_rails"
set :unicorn_config_path, "#{fetch(:deploy_to)}/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/pids/unicorn.pid"

set :environment, 'production'
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_environment, ->{ fetch(:rails_env) }
set :whenever_variables, ->{ "environment=#{fetch(:rails_env)}" }

fetch(:ssh_options)[:auth_methods] = ["publickey"]
fetch(:ssh_options)[:keys] = ["/home/chanchu/Desktop/me-key-pair-max.pem"]
# fetch(:ssh_options)[:keys] = ["/Users/martynchamberlin/Dropbox/sites/Happzee/myhaps-staging.pem"]
set :branch, "master"

set :rvm1_ruby_version, '2.1.5@myhaps_production' # Change to your ruby version
set :rvm_type, :user #if RVM installed in $HOME

#set :linked_files, fetch(:linked_files, []).push('config/production.sphinx.conf')

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
