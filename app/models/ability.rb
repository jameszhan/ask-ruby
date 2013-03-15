class Ability
  include CanCan::Ability

  def initialize(user)

    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
    elsif user.is?(:admin)
      # admin
      can :manage, :all
    elsif user.is?(:member)
      auth_control(user, Question, Tag, Answer, Comment)  
    else
      # banned or unknown situation
      cannot :manage, :all
      basic_read_only
    end
  end

  protected
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
