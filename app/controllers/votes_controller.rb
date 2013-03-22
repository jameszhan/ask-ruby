class VotesController < ApplicationController
  before_filter :find_votable

  def up
    @vote_type = :up
    do_vote!(1)
    render partial: "vote"
  end
  
  def down
    @vote_type = :down
    do_vote!(-1)
    render partial: "vote"
  end
  
  protected
    def do_vote!(value)
      if can? @vote_type, Mongoid::Vote 
        value = should_vote(value)           
        @votable.vote!(value, current_user)      
        @average = @votable.votes_average
      else
        @error = "You don't have permission to vote."
      end
    end
      
    def should_vote(value)
      current_value = current_user.vote_on(@votable) || 0
      if value * current_value > 0
        @msg = "You have revoke your vote #{@vote_type}"
        value * -1
      elsif value * current_value < 0
        @msg = "You have change your attitude to vote #{@vote_type}"
        value * 2
      else
        @msg = "Thanks for your vote #{@vote_type}"
        value        
      end        
    end
    
    def find_votable
      @votable = find_resource_by_nested_path
    end

end
