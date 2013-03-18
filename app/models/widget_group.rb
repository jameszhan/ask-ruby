class WidgetGroup
  include Mongoid::Document
  include Mongoid::DebugCallbacks
  
  field :name
  field :_id, type: String, default: ->{ name.try(:parameterize) }

  validates_length_of :name, :minimum => 1  
  validates_uniqueness_of :name
  
  embedded_in :node, :inverse_of => :widget_groups
  
  POSITIONS = %w[header footer navbar sidebar]
  
  POSITIONS.each do |position|
    embeds_many "#{position}_widgets".to_sym, class_name: 'Widget', as: :widgetable, cascade_callbacks: true
  end
  
  def find_widgets(position)
    send("#{position}_widgets".to_sym)
  end
    
end