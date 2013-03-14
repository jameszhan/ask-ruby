# encoding: UTF-8
module MongoidExt
  module Vote
    field :voter_id
    index :voter_id => 1
    embedded_in :votable, polymorphic: true, :inverse_of => :votes, :counter_cache => true
  end
end
