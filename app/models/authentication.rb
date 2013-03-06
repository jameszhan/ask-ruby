class Authentication
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  #belongs_to :user
  embedded_in :user
end
