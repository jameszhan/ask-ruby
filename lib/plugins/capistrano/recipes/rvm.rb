set_default :ruby_version, "1.9.3"

namespace :rvm do
  desc "Install RVM, Ruby, and the Bundler gem"
  task :install, roles: :app do    
    run "#{sudo} apt-get -y install curl git-core"
    run "#{sudo} curl -L https://get.rvm.io | sudo bash -s stable"
    run "#{sudo} chown -R #{user}:rvm /usr/local/rvm"
    run "#{sudo} apt-get -y --no-install-recommends install build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev libgdbm-dev ncurses-dev automake libtool bison subversion pkg-config libffi-dev"
    run "rvm install #{ruby_version}"
    run "gem install bundler --no-ri --no-rdoc"
  end
  #Uncomment this line if you want to use rvm
  after "deploy:install", "rvm:install" 
  
end
