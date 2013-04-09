class Photo
  include Mongoid::Document  
  include Mongoid::Timestamps
  
  field :image  
  belongs_to :user
  
  mount_uploader :image, PhotoUploader
  
end
