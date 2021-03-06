require "bundler/capistrano"

server "54.214.3.99", :web, :app, :db, primary: true
#server "ec2-184-169-199-112.us-west-1.compute.amazonaws.com", :web, :app, :db, primary: true

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

set :shared_children, shared_children + %w{public/users public/uploads public/photos}

namespace :db do
  desc "load db seed."
  task :seed, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    migrate_env = fetch(:migrate_env, "")
    migrate_target = fetch(:migrate_target, :latest)

    directory = case migrate_target.to_sym
      when :current then current_path
      when :latest  then latest_release
      else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
    end

    run "cd #{directory} && #{rake} RAILS_ENV=#{rails_env} #{migrate_env} db:seed"
  end
end
after "deploy:migrate", "db:seed"


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

set :recipe_mods, [:rbenv, :check, :nginx, :nodejs, :unicorn, :redis, :mongodb]

require File.expand_path("../../lib/plugins/capistrano/init", __FILE__)
