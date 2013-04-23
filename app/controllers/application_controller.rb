class ApplicationController < ActionController::Base    
  include SessionFilter
  protect_from_forgery

  before_filter :find_node
  before_filter :set_locale
  
  rescue_from CanCan::AccessDenied do |exception|
    if request.xhr?
      flash[:error] = exception.message
      render :status => 403
    else
      redirect_to questions_path, :alert => t("common.access_denied")
    end
  end  
 
  def find_questions()    
    @questions = current_node.questions
    unless current_tags.empty?
      @questions = @questions.tagged_with(*current_tags)
    end
    if current_order
      @questions = @questions.order_by(current_order)
    end
    @questions = @questions.page params[:page]
    respond_to do |format|
      format.html 
      format.json  { render json: @questions.to_json(:except => %w[node]) }
      format.atom
    end
  end
  
  def current_node
    @current_node
  end
  
  def preview
    @body = params[:body]
    render :json => {:body => markdown(@body).html_safe}
  end
  
  def markdown(text)
    return "" unless text
    renderer = Markdown::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe  
  end
      
  helper :votes
  helper_method :current_node, :current_tags, :markdown
  
  protected 
    def find_node
      @current_node ||= begin
        NodeSelector.lookup params
      end
      @current_node
    end    
    
    def set_locale
      I18n.locale = params[:locale] || session[:locale] || "zh-CN"
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
