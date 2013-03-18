class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :read, default: false
  field :source, type: String
  field :source_id, type: String
  belongs_to :user

end
