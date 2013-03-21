class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
    elsif user.roles_on(current_node).include?(:admin) || user.roles_on(current_node).include?(:moderator)
      can :manage, :all
    elsif user.roles_on(current_node).include?(:member) || user.roles_on(current_node).include?(:user)
      auth_control(user, Question, Tag, Answer, Comment, Mongoid::Vote)  
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
