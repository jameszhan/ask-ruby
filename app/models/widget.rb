class Widget
  include Mongoid::Document
  
  class << self
    def subclasses
      @subclasses ||= []
    end
    
    def inherited(base)
      subclasses << base
      super
    end
  end
  
  field :name, :type => String
  field :settings, :type => Hash
  field :position, :type => String  
  
  field :_id, type: String, default: ->{ name.try(:parameterize) }

  validates_presence_of :name
  validates_length_of :name, :minimum => 1  
  validates_uniqueness_of   :name  
  validate :check_settings
  before_create :set_name

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


  embedded_in :widget_list, polymorphic: true
  
  def partial_name
    "widgets/#{self.name}"
  end

  def description
    @description ||= I18n.t("widgets.#{self.name}.description") if self.name
  end
  
  def cache_key(params)
    ""
  end
  
  def accept?(params)
    true
  end

  protected
    def limit_to_int
      self[:settings]['limit'] = self[:settings]['limit'].to_i
    end

    def set_name
      puts "Hello " * 100
      if self.name
        self.name.parameterize("_")
      else
        self.name = self.class.to_s.demodulize.sub("Widget", "").underscore.parameterize("_")
      end      
    end

    def check_settings
    end
end

