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
  
  
  helper_method :current_tags
end
