class ApplicationController < ActionController::Base
  include SessionFilter
    
  protect_from_forgery
  
  before_filter :find_node
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to questions_path, :alert => t("common.access_denied")
  end  
 
  def find_questions()    
    @questions = current_node.questions.minimal
    unless current_tags.empty?
      @questions = @questions.tagged_with(*current_tags)
    end
    if current_order
      @questions = @questions.order_by(current_order)
    end
    respond_to do |format|
      format.html 
      format.json  { render json: @questions.to_json(:except => %w[node]) }
      format.atom
    end
  end
  
  def current_node
    @current_node
  end
  
  
  helper :votes
  helper_method :current_node, :current_tags
  
  private 
    def find_node
      @current_node ||= begin
        Node.where(name: 'default').first_or_create!
      end
      @current_node
    end
    
    def find_resource_by_nested_path
      #TODO Here is a hole of this method, since we depend on a ordered hash.
      target = nil
      request.path_parameters.each do |name, value|
        if name =~ /(.+)_id$/
          if target 
            target = target.send($1.pluralize.to_sym).find(value)
          else
            target = $1.classify.constantize.find(value)
          end          
        end
      end
      target
    end
    
    def send_notication(source, receiver)
      if receiver != current_user 
        Notification.create(source_type: source.class, source_id: source.id, user: receiver) 
      end
    end
  
  
end
