class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
         :trackable, :validatable, :omniauthable
         
  attr_accessor :login_type

  ## Database authenticatable       
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String  
  
  field :name, :type => String
  
  field :friend_ids, :type => Array, :default => []  
  
  field :following_count, default: 0  
  field :followers_count, default: 0
  
  has_and_belongs_to_many :following, class_name: 'User', inverse_of: :followers, :counter_cache => true, autosave: true
  has_and_belongs_to_many :followers, class_name: 'User', inverse_of: :following, :counter_cache => true
    
  #has_many :authentications, :dependent => :destroy
  embeds_many :authentications
  embeds_many :priviledges
  
  has_many :questions, :dependent => :destroy
  has_many :answers, :dependent => :destroy 
  
  has_many :notifications, :dependent => :destroy  
  
  set_callback(:update, :after) do |user|
    user.set(:following_count, user.following.count)
    user.set(:followers_count, user.followers.count)
  end
  
  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  
  
  @@validation = true
  def self.with_no_validation 
    @@validation = false
    yield
  ensure 
    @@validation = true
  end
    
  def self.from_omniauth(omniauth) 
    user = find_by_omniauth(omniauth).first
    unless user
      with_no_validation do
        user = create do |user|
          user.email = omniauth.info.email if omniauth.info.email
          user.password = Devise.friendly_token[0, 20]
          user.name = omniauth.info.nickname
          user.authentications.build(omniauth.slice(:provider, :uid))
        end  
      end
    end
    user.login_type = :omniauth
    user
  end
  
  def self.find_by_omniauth(omniauth)
    where(omniauth.slice(:provider, :uid).inject({}){|h, item| h.tap{h["authentications.#{item[0]}"] = item[1]}})
  end
  
  def friend_with(friend)
    if self.id != friend.id && !friend_ids.include?(friend.id)
      friend_ids << friend.id
      self.save
    end
  end
  
  def unfriend_with(friend)
    friend_ids.delete friend.id
    self.save
  end
  
  def friend_with?(friend)
    friend_ids.include?(friend.id)
  end
  
  def friends
    self.class.find(friend_ids)
  end
    
  def follow?(user)
    following.include?(user)
  end  
  
  def followed_by?(user)
    followers.include?(user)
  end
    
  def follow!(user)
    if self.id != user.id && !following.include?(user)
      following << user
    end
  end
  
  def unfollow!(user)
    following.delete(user)
  end
  
  def password_required?
    @@validation && super
  end

  def email_required?
    @@validation && super
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
  
  def method_missing(method, *args, &block)
    if !args.empty? && method.to_s =~ /can_(\w*)\_on\?/
      #TODO we should dynamic define the methods.
      key, node = $1, args.first
      if node.reputation_constrains.include?(key)
        if node.has_reputation_constrains
          config = config_for(node)
          return config.roles_in?(:admin, :moderator) || config.reputation >= node.reputation_constrains[key].to_i
        else
          return true
        end
      end
    end
    super(method, *args, &block)
  end
  
  def config_for(node)
    #priviledges.where(node_id: node.id).first_or_create  #This not working for embeds_many 
    priviledges.where(node_id: node.id).first || priviledges.create(node_id: node.id)
  end
  
end
