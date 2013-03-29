module Observable
  
  def observers
    @observers ||= []
  end
  
  def add_observer(observer)
    unless observer.respond_to? :update
      raise ArgumentError, "observer needs to respond to `update'"
    end
    observers << observer
  end
  
  def notify_observers(*args)
    observers.each { |observer| observer.update(*args) }
  end
  

end