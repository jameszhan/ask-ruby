class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :body, type: String  
  
  belongs_to :user, :inverse_of => :answers, :counter_cache => true
  belongs_to :question, :inverse_of => :answers, :counter_cache => true

  has_many :comments, as: :commentable, :dependent => :destroy

  validates_presence_of :body
  validates_length_of :body, minimum: 5
  
  validates_presence_of :user_id
  validates_presence_of :question_id

end
