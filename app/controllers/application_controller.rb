class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to questions_path, :alert => t("common.access_denied")
  end  
  
  
  def current_tags
    @current_tags ||=  if params[:tags].kind_of?(String)
      params[:tags].split("+")
    elsif params[:tags].kind_of?(Array)
      params[:tags]
    else
      []
    end
  end
  
  def current_node
    @current_node ||= begin
      Node.where(name: 'default', summary: 'The default node.').first_or_create!
    end
    @current_node
  end
  
  helper_method :current_node, :current_tags
end
