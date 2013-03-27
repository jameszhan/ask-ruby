class Node
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :name
  field :summary, default: "Default Node"
  field :questions_count, :type => Integer, :default => 0 
  
  field :has_reputation_constrains, :type => Boolean, :default => true
  field :reputation_rewards, :type => Hash, :default => ::AppConfig::REPUTATION_REWARDS
  field :reputation_constrains, :type => Hash, :default => ::AppConfig::REPUTATION_CONSTRAINS
  field :daily_cap, :type => Integer, :default => 0
   
  validates_presence_of :name, :summary
  validates_uniqueness_of :name
  
  has_many :questions
  has_many :badges, :dependent => :destroy  

  embeds_many :widget_groups, cascade_callbacks: true 
  embeds_many :tags
  
  before_create :create_widget_groups   
  
  def lookup_widgets(key, position)
    widget_groups.find(key).find_widgets(position) || widget_maps.find(:default).find_widgets(position)
  end  
  
  private 
    def create_widget_groups
      create_default_widgets
    end
    
    def create_default_widgets
      unless widget_groups.where(name: 'default').first    
        widget_group = widget_groups.build(name: 'default')
        %w[welcome markdown].each do |widget_name|
          widget_group.sidebar_widgets << Widget.new(name: widget_name)
        end
        widget_group.sidebar_widgets << Shared::QuestionStatsWidget.new
      end
    end
    
end