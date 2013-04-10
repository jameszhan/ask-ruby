class User
  include Mongoid::Document
  include DeviseCallbacks  
  include OmniauthCallbacks
  include Mongoid::Friendship
  include Mongoid::Relationship
  
  mount_uploader :avatar, AvatarUploader  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  field :name, :type => String
  
  embeds_many :priviledges
    
  has_many :questions, :dependent => :destroy
  has_many :answers, :dependent => :destroy 
  
  has_many :notifications, :dependent => :destroy 
  
  after_update :crop_avatar
  
  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end 
    
  def followed_questions
    @followed_questions ||= Question.followed_by(self)
  end
  
  def vote_on(votable)
    votable.votes.where(voter: self).first.try(:value)
  end

  def read_notifications(notifications)
    notifications.each do |notification|
      notification.read = true
      notification.save
    end
  end
  
  def on_activity(activity, node)
    update_reputation(activity, node) if activity != :login
    activity_on(node, Time.zone.now)
  end
  
  def activity_on(node, date)
    day = date.utc.at_beginning_of_day
    last_day = nil
    config = config_for(node)
    if last_activity_at = config.last_activity_at
      last_day = last_activity_at.at_beginning_of_day
    end
    config.set(:last_activity_at, date.utc)
    
    set_activity_days(config, last_day, day)
  end  
  
  def update_reputation(key, node, v = nil)
    value = v || node.reputation_rewards[key.to_s].to_i   
    return if !value
    
    logger.info "#{self.name} received #{value} points of karma by #{key} on #{node.name}"      
    config = config_for(node)
    
    update_reputation_today(config, node, value)
    
    config.inc(:reputation, value)
  end
  
  def config_for(node)
    #priviledges.where(node_id: node.id).first_or_create  #This not working for embeds_many 
    priviledges.where(node_id: node.id).first || priviledges.create(node_id: node.id)
  end
  
  def method_missing(method, *args, &block)
    if !args.empty? && method.to_s =~ /can_(\w*)\_on\?/
      define_can_method(method, $1)
      send(method, args.first)
    else      
      super(method, *args, &block)
    end
  end
  
  private 
    def define_can_method(method, key)
      self.class.send :define_method, method do |node|
        if node.reputation_constrains.include?(key)
          if node.has_reputation_constrains
            config = config_for(node)
            return config.roles_in?(:admin, :moderator) || config.reputation >= node.reputation_constrains[key].to_i
          else
            return true
          end
        end
      end
    end
    
    def update_activity_days(config, last_day, day)
      if last_day && last_day != day
        if last_day.utc.between?(day.yesterday - 12.hours, day.tomorrow)
          config.inc(:activity_days, 1)
        elsif !last_day.utc.today? && (last_day.utc != Time.now.utc.yesterday)
          logger.info ">> Resetting act days!! last known day: #{last_day}"
          config.set(:activity_days, 0)
        end
      end
    end
    
    def update_reputation_today(config, node, value)
      today = Time.now.strftime("%Y%m%d")
      if config.reputation_today.include?(today)
        total_today = config.reputation_today[today] + value
        if node.daily_cap != 0 && total_today > node.daily_cap
          logger.info "#{id}@#{config.id} hitted daily cap"
        end
        config.set("reputation_today.#{today}", total_today)
      else
        config.set("reputation_today.#{today}", value)
      end      
    end
    
    def logger 
      @logger ||= Rails.logger
    end
  
end
