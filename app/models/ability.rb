class Ability
  include CanCan::Ability

  def initialize(user)

    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
      puts "blank =================> #{user.as_json}"

    elsif user.is?(:admin)
      puts " admin =================> #{user.as_json}"
      # admin
      can :manage, :all
    elsif user.is?(:member)
      puts "=================> #{user.as_json}"
      # Question
      can :create, Question
      can :update, Question do |question|
        (question.user_id == user.id)
      end
      can :destroy, Question do |question|
         (question.user_id == user.id)
      end   
    else
      puts "else =================> #{user.as_json}"
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
