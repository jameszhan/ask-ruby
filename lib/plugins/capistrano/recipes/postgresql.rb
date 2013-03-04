set_default(:postgresql_host, "localhost")
set_default(:postgresql_user) { application }
set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL password for user #{postgresql_user}:" }
set_default(:postgresql_database) { "#{application}_production" }

namespace :postgresql do
  desc "Install latest stable release of PostgreSQL"
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} add-apt-repository -y ppa:pitti/postgresql"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install postgresql libpq-dev"
    #run "#{sudo} pg_createcluster 9.1 main --start"
  end
  after "deploy:install", "postgresql:install"
  
  desc "Create a database for this application"
  task :create_database, roles: :db, only: {primary: true} do 
    #You need remove the following 2 lines if database already setup.   
    #run %Q{#{sudo} -u postgres psql -c "DROP DATABASE #{postgresql_database}"}
    #run %Q{#{sudo} -u postgres psql -c "DROP USER #{postgresql_user}"}
    run %Q{#{sudo} -u postgres psql -c "CREATE USER #{postgresql_user} WITH PASSWORD '#{postgresql_password}'"}
    run %Q{#{sudo} -u postgres psql -c "CREATE DATABASE #{postgresql_database} owner #{postgresql_user}"}
  end
  after "deploy:setup", "postgresql:create_database"
  
  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
  end   
  after "deploy:setup", "postgresql:setup"
  
  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"
end

