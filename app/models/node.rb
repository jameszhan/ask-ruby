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
  
  before_create :create_widget_maps
  
  def lookup_widgets(key, position)
    widget_maps.find(key).find_widgets(position) || widget_maps.find(:default).find_widgets(position)
  end
  
  
  private 
    def create_widget_maps
      create_default_widgets
    end
    
    def create_default_widgets
      widget_map = widget_maps.build(name: 'default')
      %w[welcome markdown].each do |widget_name|
        widget_map.sidebar_widgets << Widget.new(name: widget_name)
      end
      widget_map.sidebar_widgets << Shared::QuestionStatsWidget.new
    end
    
end