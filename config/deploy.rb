# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
# config valid only for Capistrano 3.1
require 'rvm/capistrano'
require 'bundler/capistrano'

set :rvm_path, '/usr/local/rvm'
set :rvm_ruby_string, 'ruby-2.2.1'
set :application, 'bm'
set :repository, 'git://github.com/miralas/bm.git'
set :user, 'miralas'
set :use_sudo, false
server "37.143.16.58:5015", :app, :web, :db, :primary => true
set :scm, "git"
set :deploy_via, :remote_cache
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/bm'
# set :linked_files, %w{config/database.yml, config/settings.yml}
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/settings.yml)

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system config}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

after "deploy:restart", "deploy:cleanup"

desc "Open the rails console on one of the remote servers"
task :console, :roles => :app do
  hostname = find_servers_for_task(current_task).first
  port = exists?(:port) ? fetch(:port) : 22
  exec "ssh -l #{user} #{hostname} -p #{5015} -t '#{current_path}/script/rails c #{rails_env}'"
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
# namespace :deploy do
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       # execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end

#   after :publishing, :restart

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
# end

# cap production invoke[db:migrate]
# cap production invoke[db:reset]
# desc "Invoke a rake command on the remote server: cap production invoke[db:migrate]"
# task :invoke, [:command] => 'deploy:set_rails_env' do |_task, args|
#   on primary(:app) do
#     within current_path do
#       with rails_env: fetch(:rails_env) do
#         rake args[:command]
#       end
#     end
#   end
# end
