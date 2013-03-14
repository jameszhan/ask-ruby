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
        Node.where(name: 'default', summary: 'The default node.').first_or_create!
      end
      @current_node
    end
  
  
end
