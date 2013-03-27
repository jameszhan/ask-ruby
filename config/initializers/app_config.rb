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
  
  REPUTATION_RULES_CONFIG.each do |key, model_name, actions|
    if actions.any?
      model = model_name.constantize      
      rule key.to_sym, ->(ability){
        actions.each do |action, member|
          if member
            can action.to_sym, model do |resource|
              resource.user_id == user.id
            end
          else
            can action.to_sym, model
          end
        end
      }
    end
  end
  
=begin  
  rule :vote_up,              ->(ability){ can :up, Mongoid::Vote }
  rule :vote_down,            ->(ability){ can :down, Mongoid::Vote }
  rule :comment,              ->(ability){ can :create, Comment }
  rule :delete_own_comments,  ->(ability){ 
    can :destroy, Comment do |comment|
      comment.user_id == user.id
    end
  }
  rule :create_new_tags,      ->(ability){ can :create, Tag }

  {ask: Question, answer: Answer}.each do |rule_name, model|  
     rule rule_name,     ->(ability){
        can :create, model
        can :update, model do |resource|
          resource.user_id == user.id
        end
      }
  end


  {ask: Question, answer: Answer}.each do |rule_name, model|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      rule :#{rule_name},     ->(ability){
        can :create, #{model}
        can :update, #{model} do |resource|
          resource.user_id == user.id
        end
      }
    RUBY_EVAL
  end
=end
  
end
