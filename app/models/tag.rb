class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :description, type: String
  field :count, type: Integer
  
  field :_id, type: String, default: ->{ name.try(:parameterize) }

  validates_length_of :name, :minimum => 1  
  validates_uniqueness_of   :name

  belongs_to :user  
  embedded_in :node, :inverse_of => :tags

  def self.list
    all.map(&:id)
  end

  def question_count
    Question.tagged_with(id).count
  end
  
end
