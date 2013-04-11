set_default(:mongodb_endpoints, ["localhost:27017"])
set_default(:replica_sets, [])
set_default(:mongos_servers, [])
set_default(:mongodb_user) { application }
set_default(:mongodb_password) { Capistrano::CLI.password_prompt "MongoDB password for user #{mongodb_user}:" }
set_default(:mongodb_database) { "#{application}_production" }


namespace :mongodb do
  desc "Install latest stable release of mongodb"
  task :install, roles: :db do
    run "#{sudo} add-apt-repository ppa:gias-kay-lee/mongodb" do|ch, stream, data|
      press_enter( ch, stream, data)
    end
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install mongodb"
  end
  after "deploy:install", "mongodb:install"
  
  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "mongoid.yml.erb", "#{shared_path}/config/mongoid.yml"
  end   
  after "deploy:setup", "mongodb:setup"  

  %w[start stop restart].each do|command|
    desc "#{command} nginx"
    task command, roles: :db do
      run "#{sudo} service mongodb #{command}"
    end
  end
end