module Shared
  class BadgeWidget < Widget

    def accept?(params)
      params[:controller] == "badges" 
    end
  end
end