class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :body, type: String
  field :answers_count, type: Integer, default: 0
  field :views_count, type: Integer, default: 0
  field :votes_count, type: Integer, default: 0

  validates_presence_of :title
  validates_length_of   :title, in: 5..100
  validates_length_of   :body, minimum: 5, allow_blank: true

  belongs_to :user
end