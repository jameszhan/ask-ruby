RECIPE_MODULES ||= [:rbenv, :check, :nginx, :nodejs, :unicorn, :postgresql]

Capistrano::Configuration.instance.instance_eval do
  def use(mod)
    RECIPE_MODULES.include?(mod)
  end
  load File.expand_path('base.rb', File.dirname(__FILE__)) 
  Dir.glob(File.expand_path("recipes/*.rb", File.dirname(__FILE__))).sort.each { |f| load f if use File.basename(f, ".rb").to_sym }
end