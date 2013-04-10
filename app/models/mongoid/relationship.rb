# encoding: UTF-8
module Mongoid
  module Relationship
    extend ActiveSupport::Concern
    
    included do      
      field :following_count, default: 0  
      field :followers_count, default: 0

      has_and_belongs_to_many :following, class_name: 'User', inverse_of: :followers, :counter_cache => true, autosave: true
      has_and_belongs_to_many :followers, class_name: 'User', inverse_of: :following, :counter_cache => true
      
      set_callback(:update, :after) do |user|
        user.set(:following_count, user.following.count)
        user.set(:followers_count, user.followers.count)
      end
    end   
    
    def follow?(user)
      following.include?(user) if user
    end  

    def followed_by?(user)
      followers.include?(user) if user
    end

    def follow!(user)
      if user && self.id != user.id && !following.include?(user)
        following << user
      end
    end

    def unfollow!(user)
      following.delete(user)
    end


    module ClassMethods  
      #Other class method here.      
    end  
  end
end