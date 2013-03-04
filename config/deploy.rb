role :web, "10.211.55.15"                          # Your HTTP server, Apache/etc
role :app, "10.211.55.15"                          # This may be the same as your `Web` server
role :db,  "10.211.55.15", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :user, 'ubuntu'
set :application, "ask"
set :scm, "git"
set :repository,  "git://github.com/jameszhan/ask-ruby.git"
set :branch, "master"
set :deploy_via, :remote_cache 
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" #keep only the last 5 releases


#File.join(__dir__, 'recipes/*.rb')

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

require File.expand_path("../../lib/plugins/capistrano/init", __FILE__)
