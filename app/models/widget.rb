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
  after_initialize :set_name
  
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
      if self.name
        self.name.parameterize("_")
      else
        self.name = self.class.to_s.demodulize.sub("Widget", "").underscore.parameterize("_")
      end      
    end

    def check_settings
    end
end

