class VotesController < ApplicationController
  before_filter :find_votable

  def create
    if current_user 
      value = (params[:vote_up] && 1) || (params[:vote_down] && -1) || 0
      value = should_vote(value)
      if value != 0               
        @votable.vote!(value, current_user) do |val, type|
          @vote_type = val > 0 ? "vote-up" : (val < 0 ? "vote-down" : "vote-nothing")
          case type
          when :created
            @msg = "Thanks for voting #{val > 0 ? 'up' : 'down' }"
          when :updated
            @msg ||= "You have already update to vote #{val > 0 ? 'up' : 'down'}"
          when :destroyed
            @msg ||= "You have already revoke your vote"
          end
        end
      end
      @average = @votable.votes_average
    else
      @msg = "You must login first."
      @error ||= @msg
    end
  end

  protected
    def should_vote(value)
      current_value = current_user.vote_on(@votable) || 0
      if current_value > 0 && value > 0
        @msg = "You have revoke your vote up"
        -1
      elsif current_value < 0 && value < 0
        @msg = "You have revoke your vote down"
        1
      elsif current_value > 0 && value < 0 || current_value < 0 && value > 0 
        2 * check(value)           
      else
        check(value)
      end
    end
    
    def check(value)
      if value > 0 && current_user.can_vote_up_on?(current_node) || value < 0 && current_user.can_vote_down_on?(current_node)
        value
      else  
        @error = "You don't have permission to vote."
        0
      end
    end
    
    def find_votable
      @votable = find_resource_by_nested_path
    end

end
