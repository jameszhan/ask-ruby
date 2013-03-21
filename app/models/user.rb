class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
         :trackable, :validatable, :omniauthable

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
  

  #has_many :authentications, :dependent => :destroy
  embeds_many :authentications
  embeds_many :priviledges
  
  has_many :questions, :dependent => :destroy
  has_many :answers, :dependent => :destroy 
  
  has_many :notifications, :dependent => :destroy
  
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
      NotificationMailer.user_welcome_email(user).deliver!
    end
    user
  end
  
  def self.find_by_omniauth(omniauth)
    where(omniauth.slice(:provider, :uid).inject({}){|h, item| h.tap{h["authentications.#{item[0]}"] = item[1]}})
  end
  
  def password_required?
    @@validation && super
  end

  def email_required?
    @@validation && super
  end
  
  def roles_on(node)
    config = config_for(node)
    config.roles
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
      node = args.first
      if node.reputation_constrains.include?($1)
        if node.has_reputation_constrains
          config = config_for(node)
          return config.roles.include?(:admin) || config.roles.include?(:moderator) || config.reputation >= node.reputation_constrains[key].to_i
        else
          return true
        end
      end
    end
    super(method, *args, &block)
  end
  
  protected
    def config_for(node)
      priviledges.where(node_id: node.id).first_or_create
    end
  
end
