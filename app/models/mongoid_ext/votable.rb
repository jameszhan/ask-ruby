# encoding: UTF-8
module MongoidExt
  module Votable
    extend ActiveSupport::Concern
    
    included do
      field :votes_count, type: Integer, default: 0
      field :votes_average, type: Integer, default: 0
      field :votes_up, type: Integer, default: 0
      field :votes_down, type: Integer, default: 0
      
      embeds_many :votes
    end  

    module ClassMethods  
      #Other class method here.      
    end  
  end
end


