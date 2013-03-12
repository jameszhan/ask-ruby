class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Taggable
  
  field :title, type: String
  field :body, type: String
  field :answers_count, type: Integer, default: 0
  field :views_count, type: Integer, default: 0
  field :votes_count, type: Integer, default: 0

  validates_presence_of :title
  validates_length_of   :title, in: 5..100
  validates_length_of   :body, minimum: 5, allow_blank: true

  belongs_to :user
  belongs_to :node
  has_many :answers
  index :node_id => 1

  def viewed!(ip)
    view_count_id = "#{self.id}-#{ip}"
    if ViewsCount.where({ identity: view_count_id }).first.nil?
      ViewsCount.create(identity: view_count_id)
      self.inc(:views_count, 1)
    end    
  end
end