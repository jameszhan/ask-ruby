class WidgetMap  
  include Mongoid::Document
  
  field :name
  field :_id, type: String, default: ->{ name.try(:parameterize) }

  validates_length_of :name, :minimum => 1  
  validates_uniqueness_of :name


  after_initialize lambda{|record| puts "#{record} => after_initialize!"; true }
  after_build lambda{|record| puts "#{record} => after_build!"; true }
  before_validation lambda{|record| puts "#{record} => before_validateion!"; true }
  after_validation lambda{|record| puts "#{record} => after_validation!"; true }
  before_create lambda{|record| puts "#{record} => before_create!"; true }
  around_create lambda{|record, block| puts "#{record} => around_create:before"; block.call; puts "#{record} => around_create:after" }
  after_create lambda{|record| puts "#{record} => after_create!"; true }
  after_find lambda{|record| puts "#{record} => after_find!"; true }
  before_update lambda{|record| puts "#{record} => before_update!"; true }
  around_update lambda{|record, block| puts "#{record} => around_update:before"; block.call; puts "#{record} => around_update:after" }
  after_update lambda{|record| puts "#{record} => after_update!"; true }
  before_upsert lambda{|record| puts "#{record} => before_upsert!"; true }
  around_upsert lambda{|record, block| puts "#{record} => around_upsert:before"; block.call; puts "#{record} => around_upsert:after" }
  after_upsert lambda{|record| puts "#{record} => after_upsert!"; true }
  before_save lambda{|record| puts "#{record} => before_save!"; true }
  around_save lambda{|record, block| puts "#{record} => around_save:before"; block.call; puts "#{record} => around_save:after" }
  after_save lambda{|record| puts "#{record} => after_save!"; true }
  before_destroy lambda{|record| puts "#{record} => before_destroy!"; true }
  around_destroy lambda{|record, block| puts "#{record} => around_destroy:before"; block.call; puts "#{record} => around_destroy:after" }
  after_destroy lambda{|record| puts "#{record} => after_destroy!"; true }

  
  embedded_in :node, :inverse_of => :widget_maps
  
  POSITIONS = %w[header footer navbar sidebar]
  
  POSITIONS.each do |position|
    embeds_many "#{position}_widgets".to_sym, class_name: 'Widget', as: :widget_list, cascade_callbacks: true
  end
  
  def find_widgets(position)
    send("#{position}_widgets".to_sym)
  end
    
end