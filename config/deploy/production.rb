set :rails_env, 'production'
set :deploy_to, "/var/www/production"
set :branch, 'production'

namespace :deploy do

  desc "Update the crontab file"
  task :update_crontab, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && bundle exec whenever -w"
  end

end

after "deploy:restart", "deploy:update_crontab"