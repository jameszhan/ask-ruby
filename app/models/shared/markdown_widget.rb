module Shared
  class MarkdownWidget < Widget

    def accept?(params)
      params[:controller] == "questions" && (params[:action] == "show" || params[:action] == "new") 
    end
  end
end