class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :summary
  field :questions_count, :type => Integer, :default => 0  
  
  has_many :questions
  
  validates_presence_of :name, :summary
  validates_uniqueness_of :name
  
  embeds_many :widget_maps  
  embeds_many :tags
  
  before_create :create_default_widgets
  
  def lookup_widgets(key, position)
    widget_maps.find(key).find_widgets(position) || widget_maps.find(:default).find_widgets(position)
  end
  
  
  private 
    def create_default_widgets
      widget_map = widget_maps.build(name: 'default')
      widget = Shared::MarkdownWidget.new
      puts widget_map.sidebar_widgets
      widget_map.sidebar_widgets << widget
    end
      
end