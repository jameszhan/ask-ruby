# encoding: UTF-8
module MongoidExt
  module Votable
    extend ActiveSupport::Concern
    
    included do
      field :votes_count, type: Integer, default: 0
      field :votes_average, type: Integer, default: 0
      field :votes_up, type: Integer, default: 0
      field :votes_down, type: Integer, default: 0
      
      #TODO Here should we use Hash???
      embeds_many :votes, as: :votable, class_name: "MongoidExt::Vote"
      
      scope :voted_by, ->(voter) do
        where("votes.voter" => voter)
      end
    end  
    
    def voted?(voter)
      votes.where(voter: voter).first != nil
    end
    
    def vote!(value, voter)
      vote = votes.where(voter: voter).first
      if vote
        new_value = vote.value + value
        if new_value == 0
          votes.delete(vote)
          do_vote!(vote, value, :destroyed)
          if block_given?
            yield :destroyed 
          else
            return :destroyed
          end
        else
          vote.inc(:value, value)
          do_vote!(vote, value, :updated)
          if block_given?
            yield :updated 
          else
            return :updated
          end
        end
      else
        votes.create(voter: voter, value: value)
        do_vote!(vote, value, :created)
        if block_given?
          yield :created
        else
          return :created
        end
      end
    end
    
    def do_vote!(vote, value, status)
      case status
        when :created
          if value > 0 
            inc(:votes_up, 1)
          else
            inc(:votes_down, 1)
          end
          inc(:votes_count, 1)
        when :updated
          #Origin is vote down, but now is vote up
          if vote.value - value < 0 && vote.value > 0
            inc(:votes_up, 1)
            inc(:votes_down, -1)
          #Origin is vote up, but now is vote down
          elsif vote.value - value > 0 && vote.value < 0 
            inc(:votes_down, 1)
            inc(:votes_up, -1)
          end
        when :destroyed
          if value > 0
            inc(:votes_down, -1)
          else
            inc(:votes_up, -1)
          end
          inc(:votes_count, -1)          
        else
          raise "Not accept status"
      end    
      inc(:votes_average, value)
      #set(:votes_average, votes.map(&:value).reduce(0, &:+))
    end
    
    
    module ClassMethods  
      #Other class method here.      
    end  
  end
end


