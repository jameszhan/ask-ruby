class VotesController < ApplicationController
  before_filter :find_voteable

  def create
    if current_user 
      value = (params[:vote_up] && 1) || (params[:vote_down] && -1) || 0
      current_value = 0
      if value != 0        
        value = vote_value(value)
        @votable.vote!(value, current_user) do |val, type|
          current_value = val
          case type
          when :created
            if val > 0
              @msg = "Thanks for voting up the question"
            else
              @msg = "Thanks for voting down the question"
            end
          when :updated
            if val > 0
              @msg = "You have already update to vote up the question"
            else
              @msg = "You have already update to vote down the question"
            end
          when :destroyed
            @msg = "You have already vote up the question"
          end
        end
      end
      @average = @votable.votes_average
      @vote_type = current_value > 0 ? "vote-up" : (current_value < 0 ? "vote-down" : "vote-nothing")
    else
      @msg = @error = "You must login first."
    end
  end

  protected
    def vote_value(value)
      current_value = current_user.vote_on(@votable) || 0
      if current_value > 0 && value > 0
        -1
      elsif current_value < 0 && value < 0
        1
      elsif current_value > 0 && value < 0 || current_value < 0 && value > 0 
        value * 2
      else
        value
      end
    end
    def find_voteable
      #TODO Here is a hole of this method, since we depend on a order hash.
      request.path_parameters.each do |name, value|
        if name =~ /(.+)_id$/
          if @votable 
            @votable = @votable.send($1.pluralize.to_sym).find(value)
          else
            @votable = $1.classify.constantize.find(value)
          end          
        end
      end
    end

end
