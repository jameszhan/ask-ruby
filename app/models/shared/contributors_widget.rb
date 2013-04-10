module Shared
  class ContributorsWidget < Widget

    def accept?(params)
      params[:controller] == "questions" && params[:action] == "index" 
    end
  end
end