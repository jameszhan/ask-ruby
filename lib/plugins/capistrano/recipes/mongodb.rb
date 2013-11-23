puts "2: #{self}"
set_default(:mongodb_endpoints, ["localhost:27017"])
set_default(:replica_sets, [])
set_default(:mongos_servers, [])
set_default(:mongodb_user) { application }
set_default(:mongodb_password) { Capistrano::CLI.password_prompt "MongoDB password for user #{mongodb_user}:" }
set_default(:mongodb_database) { "#{application}_production" }


namespace :mongodb do
  desc "Install latest stable release of mongodb"
  task :install, roles: :db do
    run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
    run "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /tmp/10gen.list"
    run "#{sudo} mv /tmp/10gen.list /etc/apt/sources.list.d/"
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get install mongodb-10gen"
#    run "#{sudo} add-apt-repository ppa:gias-kay-lee/mongodb" do|ch, stream, data|
#      press_enter( ch, stream, data)
#    end
#    run "#{sudo} apt-get -y update"
#    run "#{sudo} apt-get -y install mongodb"
  end
  after "deploy:install", "mongodb:install"
  
  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "mongoid.yml.erb", "#{shared_path}/config/mongoid.yml"
  end   
  after "deploy:setup", "mongodb:setup"  
  
  desc "Symlink the mongoid.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end
  after "deploy:finalize_update", "mongodb:symlink"

  %w[start stop restart].each do|command|
    desc "#{command} nginx"
    task command, roles: :db do
      run "#{sudo} service mongodb #{command}"
    end
  end
end