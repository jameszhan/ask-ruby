class Priviledge
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :active, ->{ where(:state => "active") }

  ROLES = [:member, :user, :moderator, :admin, :owner]

  field :state, :type => String, :default => 'active'
  field :reputation, :type => Float, :default => 0.0
  field :roles, :type => Array, :default => [:member]
  field :profile, :type => Hash, :default => {} 

  embedded_in :user, :inverse_of => :priviledges
  belongs_to :node

  validates_presence_of :node
  validates_uniqueness_of :node_id
  #validates_presence_of :user
  #validates_uniqueness_of :user_id, :scope => [:node_id]  

  index :roles => 1
  index :reputation => 1
  index :state => 1
  index({ node_id: 1 }, { unique: true })
  index({ state: 1, node_id: 1 })
  
  def roles_in?(*user_roles)
    (roles & user_roles).any?
  end


end
