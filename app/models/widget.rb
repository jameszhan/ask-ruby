class Widget
  include Mongoid::Document
  #include Mongoid::DebugCallbacks
  
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
  
  #TODO There is open bugs in mongoid
  after_initialize :set_name

  embedded_in :widgetable, polymorphic: true
  
  def partial_name
    "widgets/#{name.underscore.parameterize("_")}"
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
      self.name ||= self.class.to_s.demodulize.sub("Widget", "").underscore.parameterize("_")   
    end

    def check_settings
    end
end

