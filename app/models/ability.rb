class Ability
  include CanCan::Ability
  
  def initialize(user)
    @user = user
    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
    elsif user.config_for(current_node).roles_in?(:admin, :moderator)
      can :manage, :all
    elsif user.config_for(current_node).roles_in?(:member, :user)      
      #auth_control(user, Question, Tag, Answer, Comment)
      reputation_rules(user)  
      can :follow, Question
      can :unfollow, Question
    else
      # banned or unknown situation
      cannot :manage, :all
      basic_read_only
    end
  end
  
  protected  
    def current_node
      @current_node ||= NodeSelector.current_node
    end
    
    def reputation_rules(user)
      puts AppConfig::REPUTATION_RULES
      AppConfig::REPUTATION_RULES.each do |name, blk|
        puts "> can_#{name}_on?"
        if user.send("can_#{name}_on?", current_node)
          puts "^" * 100
          puts "< can_#{name}_on?"
          instance_eval &blk
        end
      end
    end
    
    def auth_control(user, *resources)
      resources.each do |resource_class|
        can :create, resource_class
        can :update, resource_class do |resource|
          resource.user_id == user.id
        end
        can :destroy, resource_class do |resource|
          resource.user_id == user.id
        end
      end
    end
    
    def basic_read_only
      can :read, Question, Tag    
    end
    
    def user
      @user
    end
    
    def logger
      @logger ||= Rails.logger
    end
end
