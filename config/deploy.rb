set :user, "root"
set :application, "railsrankings"
set :domain, "209.20.84.38"
set :scm_verbose, true
default_run_options[:pty] = true
set :repository,  "git@github.com:cricketgeek/railsrankings.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :branch, 'master'

role :app, domain
role :web, domain
role :db,  domain, :primary => true