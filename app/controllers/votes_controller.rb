class VotesController < ApplicationController
  before_filter :find_voteable

  def create
    if current_user 
      value = (params[:vote_up] && 1) || (params[:vote_down] && -1) || 0
      puts "xxx" * 100
      puts "vote before => #{value}"
      value = should_vote(value)
      puts "vote after => #{value}"
      if value != 0               
        @votable.vote!(value, current_user) do |val, type|
          @vote_type = val > 0 ? "vote-up" : (val < 0 ? "vote-down" : "vote-nothing")
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
    else
      @msg = "You must login first."
      @error ||= @msg
    end
  end

  protected
    def should_vote(value)
      current_value = current_user.vote_on(@votable) || 0
      if current_value > 0 && value > 0
        -1
      elsif current_value < 0 && value < 0
        1
      elsif current_value > 0 && value < 0 || current_value < 0 && value > 0 
        check(value){ |val| val * 2 }            
      else
        check(value){ |val| val }  
      end
    end
    
    def check(value)
      if value > 0 && current_user.can_vote_up_on?(@votable) || value < 0 && current_user.can_vote_down_on?(@votable)
        yield value
      else  
        @error = "You don't have permission to vote."
        0
      end
    end
    
    def find_voteable
      #TODO Here is a hole of this method, since we depend on a ordered hash.
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
