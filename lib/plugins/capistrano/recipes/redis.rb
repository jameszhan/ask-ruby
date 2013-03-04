namespace :redis do
  desc "Install latest stable release of redis-server"
  task :install, roles: :app do
    run "#{sudo} add-apt-repository -y ppa:chris-lea/redis-server"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install redis-server"    
  end
  after "deploy:install", "redis:install"
    
  %w[start stop restart].each do|command|
    desc "#{command} redis"
    task command, roles: :app do
      run "#{sudo} service redis-server #{command}"
    end
  end  
end

namespace :resque do
  task :start do
    run %Q{RAILS_ENV=production VVERBOSE=1 start-stop-daemon --start --pidfile #{shared_path}/pids/reseque.pid\
    -u #{user} -d #{current_path} --background --exec /usr/bin/env -- rake environment resque:work}
  end
end

