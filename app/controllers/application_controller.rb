class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to questions_path, :alert => t("common.access_denied")
  end  
end
