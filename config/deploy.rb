require 'capistrano/ext/multistage'

set :user, "root"
set :application, "railsrankings"
set :domain, "209.20.84.38"
set :scm_verbose, true
set :keep_releases, 8

default_run_options[:pty] = true
set :repository,  "git@github.com:cricketgeek/railsrankings.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"
set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"  

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :branch, 'master'

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Perform a deploy:setup and deploy:cold"
  task :init do 
    transaction do
      deploy.setup
      deploy.cold
    end
  end
  
  desc "Perform a code update, sanity_check, symlink and migration"
  task :full do
    transaction do
      deploy.update
      
      deploy.stop
      sleep(3)
      deploy.start
      deploy.cleanup
    end
  end
  
  %w(start stop restart).each do |action|
    desc "#{action} the Mongrel cluster"
    task action.to_sym do
      find_and_execute_task("mongrel:cluster:#{action}")
    end
  end

end

namespace :add_tasks do

  desc "reset sphinx"
  task :reset_ts, :roles => :app do
    run "cd #{current_path} && rake ts:stop RAILS_ENV=#{rails_env}"
    run "cd #{current_path} && rake ts:index RAILS_ENV=#{rails_env}"
    run "cd #{current_path} && rake ts:start RAILS_ENV=#{rails_env}"
  end
    
  desc "stop thinking sphinx"
  task :stop_ts, :roles => :app do
    run "cd #{current_path} && rake ts:stop RAILS_ENV=#{rails_env}"
  end

  desc "index thinking sphinx"
  task :index, :roles => :app do
    run "cd #{current_path} && rake ts:index RAILS_ENV=#{rails_env}"
  end

  desc "start thinking sphinx"
  task :start_ts, :roles => :web do
    run "cd #{current_path} && rake ts:start RAILS_ENV=#{rails_env}"
  end
end
