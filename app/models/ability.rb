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
      # Question
      can :create, Question
      can :update, Question do |question|
        question.user_id == user.id
      end
      can :destroy, Question do |question|
        question.user_id == user.id
      end   
    else
      # banned or unknown situation
      cannot :manage, :all
      basic_read_only
    end
  end

  protected
    def basic_read_only
      can :read, Question     
    end
end
