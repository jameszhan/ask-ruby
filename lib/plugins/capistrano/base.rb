Capistrano::Configuration.instance.instance_eval do
  def set_default(name, *args, &block)
    set(name, *args, &block) unless exists?(name)
  end

  set_default :recipe_mods, [:rbenv, :check, :nginx, :nodejs, :unicorn, :postgresql]
  def using?(mod)
    recipe_mods.include?(mod)
  end

  def template(from, to)
    tmpl = File.read(File.expand_path("recipes/templates/#{from}", File.dirname(__FILE__)))    
    put ERB.new(tmpl).result(binding), to
  end
  
  namespace :deploy do
    task :install do
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install python-software-properties"
    end
  end
  
  Dir.glob(File.expand_path("recipes/*.rb", File.dirname(__FILE__))).sort.each { |f| load f if using? File.basename(f, ".rb").to_sym }
end