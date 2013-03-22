class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :read, default: false
  field :source_type, type: String
  field :source_id, type: String
  
  belongs_to :user
  
  validates_presence_of :source_type, :source_id, :user_id
  
end
