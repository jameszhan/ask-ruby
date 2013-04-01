class NodeSelector
  include Singleton
  include Observable  
  include ActiveSupport::Callbacks
  
  class << self
    extend Forwardable

    def_delegators :instance, :lookup, :add_observer, :current_node
  end  
  
  define_callbacks :lookup  
  set_callback :lookup, :after, ->(node, block) do
    logger.debug "notify observers... @#{self}"    
    notify_observers(block.call)
  end  
  
  def current_node
    @current_node || self.lookup("")
  end
  
  def lookup(params)
    logger.debug "Lookup... #{params} @#{self}"
    run_callbacks :lookup do
      @current_node = Node.where(name: 'default').first_or_create!
    end
  end
  
  protected 
    def logger
      @logger ||= Rails.logger
    end
    
end
