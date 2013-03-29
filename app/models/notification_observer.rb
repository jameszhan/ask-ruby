class NotificationObserver < Mongoid::Observer
  observe :user, :node, :answer, :question
  
  %w[before after].each do |type|
    %w[initialize build validation create find update save destroy].each do |action|
      class_eval <<-CALLBACK, __FILE__, __LINE__ + 1
        def #{type}_#{action}(model)
          execute_callback("#{type}", model, "#{action}")
        end
      CALLBACK
    end
  end
  
  protected 
    def execute_callback(type, model, action)
      callback_name = "#{type}_#{model.class.to_s.underscore}_#{action}".to_sym
      if respond_to?(callback_name, true)
#        logger.debug "* Execute callback => #{type}, #{model}, #{action}"
        send(callback_name, model)
      else
#        logger.debug "* Ignore callback => #{type}, #{model}, #{action}"
      end
    end
    
    def after_question_create(question)
      question.user.update_reputation("ask_question", question.node)
    end
    
    def after_answer_create(answer)
      answer.user.update_reputation("answer_question", answer.question.node)
    end
    
    def after_user_create(user)      
      Notifier.user_welcome_email(user).deliver! unless user.email.blank?
      Node.all.each do |node|        
        user.update_reputation(:user_sign_up, node, 20)
      end
    end 
    
    def after_answer_create(answer)
      if answer.persisted?  
        begin      
          #send_notication(answer, answer.question.user)        
          Notifier.answer_notify_email(answer).deliver
        rescue Exception => e
          logger.warn e.message + e.backtrace.join("\n")   
        end      
      end
    end
    
    def logger
      @logger ||= Rails.logger
    end
  
end
