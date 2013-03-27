# encoding: UTF-8
module Mongoid
  module Friendship
    extend ActiveSupport::Concern
    
    included do
      field :friend_ids, :type => Array, :default => []  
    end  
    
    def friend_with(friend)
      if self.id != friend.id && !friend_ids.include?(friend.id)
        friend_with!(self, friend)
        friend_with!(friend, self)
      end
    end

    def unfriend_with(friend)
      unfriend_with!(self, friend)
      unfriend_with!(friend, self)
    end

    def friend_with?(friend)
      friend_ids.include?(friend.id)
    end

    def friends
      self.class.find(friend_ids)
    end
    
    protected
      def friend_with!(from, to)
        from.friend_ids << to.id
        from.save
      end
      
      def unfriend_with!(from, to)
        from.friend_ids.delete to.id
        from.save
      end

    module ClassMethods  
      #Other class method here.      
    end  
  end
end