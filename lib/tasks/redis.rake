namespace :redis do
  task :start do
    sh "redis-server ./lib/redis.conf" do |res, stat|
      if !res
         puts stat
       end
    end
  end
end