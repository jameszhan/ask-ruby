class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :read, default: false
  field :source, type: String
  field :source_id, type: String
  belongs_to :user
  validates_presence_of :source, :source_id, :user
end
