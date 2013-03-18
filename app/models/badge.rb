class Badge
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w[gold silver bronze]
  GOLD = %w[rockstar popstar fanatic service_medal famous_question celebrity
            great_answer great_question stellar_answer stellar_question]
  SILVER = %w[popular_person guru favorite_answer favorite_question addict good_question
              good_answer notable_question civic_duty enlightened necromancer]
  BRONZE = %w[pioneer supporter critic inquirer troubleshooter commentator
              merit_medal effort_medal student shapado editor popular_question
              friendly interesting_person citizen_patrol cleanup disciplined
              nice_answer nice_question peer_pressure self-learner scholar autobiographer
              organizer tutor altruist benefactor investor promoter]
  
  def self.TOKENS
    @tokens ||= GOLD + SILVER + BRONZE
  end
  
  def self.count(token, current_node)
    Badge.where(:token => token, :node_id => current_node.id).count
  end  
  
  def self.gold_badges
    self.find_all_by_type("gold")
  end

  def self.type_of(token)
    if BRONZE.include?(token)
      "bronze"
    elsif SILVER.include?(token)
      "silver"
    elsif GOLD.include?(token)
      "gold"
    end
  end

  field :token
  field :type 
  index :token => 1
  
  validates_presence_of :token, :type
  validates_inclusion_of :type,  :in => TYPES
  validates_inclusion_of :token, :in => self.TOKENS

  belongs_to :node
  validates_presence_of :node
  
  belongs_to :user
  validates_presence_of :user
  
  belongs_to :badgable, polymorphic: true
  
  before_save :set_type
  


  def to_param
    self.token
  end

  def name(locale=I18n.locale)
    @name ||= I18n.t("badges.shared.#{self.token}.name", :default => self.token.titleize.downcase, :locale => locale) if self.token
  end

  def description
    @description ||= I18n.t("badges.shared.#{self.token}.description", default: "") if self.token
  end

  def type
    self[:type] ||= Badge.type_of(self.token)
  end

  def source=(source)
    if source
      self[:source_id] = source.id
      self[:source_type] = source.class.to_s
    else
      self[:source_id] = nil
      self[:source_type] = nil
    end
  end

  def source
    if self[:source_type]
      self[:source_type].constantize.find(self[:source_id])
    end
  end

  protected
    def set_type
      self[:type] ||= self.class.type_of(self[:token])
    end
    
end