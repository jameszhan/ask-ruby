class NotificationObserver < Mongoid::Observer
  observe :user, :node
  
  def after_create(record)
    callback_name = "after_#{record.class.to_s.underscore}_create".to_sym
    if respond_to?(callback_name, true)
      send(callback_name, record)
    end    
  end
  
  protected 
    def after_user_create(user)      
      NotificationMailer.user_welcome_email(user).deliver! unless user.email.blank?
    end 
  
end
