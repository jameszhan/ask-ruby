server "ec2-54-244-136-78.us-west-2.compute.amazonaws.com", :web, :app, :db, primary: true

set :user, 'ubuntu'
set :application, "askrubyist"
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

set :recipe_mods, [:rbenv, :check, :nginx, :nodejs, :unicorn, :redis]

require File.expand_path("../../lib/plugins/capistrano/init", __FILE__)
