class Authentication
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  belongs_to :user
end
