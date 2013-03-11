class Authentication
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  #belongs_to :user
  embedded_in :user, :inverse_of => :authentications
  
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
end
