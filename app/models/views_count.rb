class ViewsCount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :identity, type: String

  def self.cleanup!
    ViewsCount.delete_all(:created_at.lt => 8.days.ago)
  end
end