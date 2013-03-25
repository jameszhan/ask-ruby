class NotificationObserver < Mongoid::Observer
  observe :user, :node
  
  def after_create(record)
    send("after_#{record.class.underscore}_create".to_sym, record)
  end
  
  def method_missing(method, *args, &block)
    super unless method.to_s =~ /^before|after|around/
  end
  
  
  protected 
    def after_user_create(user)      
      NotificationMailer.user_welcome_email(user).deliver! unless user.email.blank?
    end 
  
end
