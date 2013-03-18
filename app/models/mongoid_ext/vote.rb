# encoding: UTF-8
module MongoidExt
  class Vote    
    include Mongoid::Document
    
    field :value    
    belongs_to :voter, polymorphic: true
    embedded_in :votable, polymorphic: true
    
    index :voter_id => 1        
  end
end


 