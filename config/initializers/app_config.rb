class AppConfig
  
  YAML.load_file(Rails.root + "config/default_reputation.yml").each do |key, value|
    const_set("REPUTATION_#{key.upcase}", value)
  end 
  
  REPUTATION_RULES = {}
  
  def self.rule(name, blk)
    if blk.is_a? Proc
      REPUTATION_RULES[name] = blk
    end
  end  
  
  def self.build_block_code(key, model, actions)
    code = %Q[
      rule :#{key}, ->(ability){
    ]
    actions.each do |action, member|
      if member
        code<< %Q{
        can :#{action}, #{model} do |resource|
          resource.user_id == user.id
        end
        }
      else
        code<< %Q{ 
        can :#{action}, #{model}
        }
      end
    end
    code<< %Q[
      }
    ]
  end
  
  REPUTATION_RULES_CONFIG.each do |key, model, actions|
    if actions.any?      
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        #{build_block_code(key, model, actions)}
      RUBY_EVAL
    end
  end
  
  
end
