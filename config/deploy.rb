set :stages, %w(production staging)
set :default_stage, "staging"

require 'capistrano/ext/multistage'
require "bundler/capistrano"

set :application, "spiderlist"
# REDACTED
# REDACTED

set :scm, :git
# REDACTED

set :deploy_via, :remote_cache

set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# REDACTED
# REDACTED
# REDACTED
# role :db,  "your slave db-server here"

set :keep_releases, 3

namespace :deploy do

  desc "Restart Passenger"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

end

after "deploy:restart", "deploy:cleanup"


after "deploy:update_code", "deploy:migrate"

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



