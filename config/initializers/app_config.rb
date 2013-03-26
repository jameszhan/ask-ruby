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
  
  rule :vote_up,              ->(ability){ can :up, Mongoid::Vote }
  rule :vote_down,            ->(ability){ can :down, Mongoid::Vote }
  rule :comment,              ->(ability){ can :create, Comment }
  rule :delete_own_comments,  ->(ability){ 
    can :destroy, Comment do |comment|
      comment.user_id == user.id
    end
  }
  rule :create_new_tags,      ->(ability){ can :create, Tag }
  rule :ask,                  ->(ability){ 
    can :create, Question
    can :update, Question do |question|
      question.user_id == user.id
    end
  }
  rule :answer,               ->(ability){ 
    can :create, Answer 
    can :update, Answer do |answer|
      answer.user_id == user.id
    end
  }
  
end
