module Shared
  class QuestionStatsWidget < Widget

    def accept?(params)
      params[:controller] == "questions" && params[:action] == "show"
    end

    def cache_keys(params)
      if params[:controller] == "questions"
        params[:id]
      else
        super
      end
    end

  end
end