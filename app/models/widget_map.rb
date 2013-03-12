class WidgetMap  
  include Mongoid::Document
  
  field :name
  field :_id, type: String, default: ->{ name.try(:parameterize) }

  validates_length_of :name, :minimum => 1  
  validates_uniqueness_of   :name
  
  embedded_in :node, :inverse_of => :widget_maps
  
  POSITIONS = %w[header footer navbar sidebar]
  
  POSITIONS.each do |position|
    embeds_many "#{position}_widgets".to_sym, class_name: 'Widget', as: :widget_list
  end
  
  def find_widgets(position)
    send("#{position}_widgets".to_sym)
  end
    
end