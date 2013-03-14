class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :body, type: String
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates_presence_of :body
  validates_length_of :body, minimum: 5
  

end
