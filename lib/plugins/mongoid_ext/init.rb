Dir["#{File.dirname(__FILE__)}/extensions/*.rb"].sort.each do |path|
  require "plugins/mongoid_ext/extensions/#{File.basename(path, '.rb')}"
end