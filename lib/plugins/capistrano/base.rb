def template(from, to)
  tmpl = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(tmpl).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties"
  end
end
