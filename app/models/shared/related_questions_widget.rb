module Shared
  class RelatedQuestionsWidget < Widget

    def accept?(params)
      params[:controller] == "questions" && params[:action] == "show"
    end
  end
end