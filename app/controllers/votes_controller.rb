class VotesController < ApplicationController
  before_filter :find_voteable

  def create
    if current_user 
      value = (params[:vote_up] && 1) || (params[:vote_down] && -1) || 0
      if value != 0
        @votable.vote!(value, current_user) do |type|
          case type
          when :created
          when :updated
          when :destroyed
          end
        end
      end
      @average = @votable.votes_average
      @msg = "Thanks for your votes."
    else
      @msg = @error = "You must login first."
    end
  end

  protected
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

    def validate_vote(value, voter)
      true
    end


end
