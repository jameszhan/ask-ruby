class AppConfig
  YAML.load_file(Rails.root + "config/default_reputation.yml").each do |key, value|
    const_set("REPUTATION_#{key.upcase}", value)
  end 
end
