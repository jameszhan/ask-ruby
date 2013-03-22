class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
    elsif user.config_for(current_node).roles_in?(:admin, :moderator)
      can :manage, :all
    elsif user.config_for(current_node).roles_in?(:member, :user)
      auth_control(user, Question, Tag, Answer, Comment)  
      can :follow, Question
      can :unfollow, Question
      can :up, Mongoid::Vote
      can :down, Mongoid::Vote
    else
      # banned or unknown situation
      cannot :manage, :all
      basic_read_only
    end
  end

  protected
    def current_node
      Node.first
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
      can :read, Question     
    end
end
