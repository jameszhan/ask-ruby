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
    put ERB.new(tmpl, nil, "-").result(binding), to
  end
  
  #BUG for "Press [ENTER] to continue or ctrl-c to cancel adding it"
  def press_enter(ch, stream, data)
    if data =~ /Press.\[ENTER\].to.continue/
      # prompt, and then send the response to the remote process
      ch.send_data("\n")
    else
      # use the default handler for all other text
      Capistrano::Configuration.default_io_proc.call(ch, stream, data)
    end
  end
  
  namespace :deploy do
    task :install do
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install python-software-properties"
    end
  end
  
  Dir.glob(File.expand_path("recipes/*.rb", File.dirname(__FILE__))).sort.each { |f| load f if using? File.basename(f, ".rb").to_sym }
end