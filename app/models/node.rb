class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :summary
  field :questions_count, :type => Integer, :default => 0  
  
  has_many :questions
  
  validates_presence_of :name, :summary
  validates_uniqueness_of :name
  
  embeds_many :widget_maps, cascade_callbacks: true 
  embeds_many :tags
  
  before_create :create_widget_maps  
  
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
  
  def lookup_widgets(key, position)
    widget_maps.find(key).find_widgets(position) || widget_maps.find(:default).find_widgets(position)
  end
  
  
  private 
    def create_widget_maps
      create_default_widgets
    end
    
    def create_default_widgets
      unless widget_maps.where(name: 'default').first    
        widget_map = widget_maps.build(name: 'default')
        #%w[welcome markdown].each do |widget_name|
        #  widget_map.sidebar_widgets << Widget.new(name: widget_name)
        #end
        widget_map.sidebar_widgets << Shared::QuestionStatsWidget.new
      end
    end
    
end