class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
    
  field :name, type: String
  field :description, type: String
  field :count, type: Integer
  
  index :name => 1

  validates_uniqueness_of :name, :allow_blank => false
  validates_length_of       :name,     :minimum => 1  
  
  belongs_to :user
    
  def self.list
    all.map(&:name)
  end
  
end
