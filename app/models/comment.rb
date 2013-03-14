class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :body, type: String
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  validates_presence_of :body
  validates_length_of :body, minimum: 5
  
  validates_presence_of :user_id
  validates_presence_of :question_id

end
