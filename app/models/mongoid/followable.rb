module Mongoid
  module Followable
    extend ActiveSupport::Concern
    
    included do
      has_and_belongs_to_many :followers, :class_name => "User", :validate => false  
    end  
    
    def followed_by!(user)
      followers << user
    end
    
    def unfollowed_by!(user)
      followers.delete(user)
    end
    
    def followed_by?(user)
      if user
        followers.include? user 
      else
        false
      end
    end
    
  end
end