class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  include Mongoid::Votable
  include Mongoid::Followable
  
  field :title,         type: String
  field :body,          type: String
  field :views_count,   type: Integer, default: 0  
  
  field :accepted,      type: Boolean, default: false
  field :closed,        type: Boolean, default: false
  field :closed_at,     type: Time    
  
  validates_presence_of :title
  validates_length_of   :title, in: 5..100
  validates_length_of   :body, minimum: 5, allow_blank: true

  belongs_to :user, :inverse_of => :questions, :counter_cache => true
  belongs_to :node, :inverse_of => :questions, :counter_cache => true
  
  belongs_to :answered_with, :class_name => "Answer"
   
  has_many :answers, :dependent => :destroy
  has_many :badges, :as => :badgable
  
  embeds_many :comments, as: :commentable, cascade_callbacks: true  
  
  index :node_id => 1  
  
  scope :minimal, -> { without(:body, :answers, :comments) }

  def viewed!(ip)
    view_count_id = "#{self.id}-#{ip}"
    if ViewsCount.where({ identity: view_count_id }).first.nil?
      ViewsCount.create(identity: view_count_id)
      self.inc(:views_count, 1)
    end    
  end
end