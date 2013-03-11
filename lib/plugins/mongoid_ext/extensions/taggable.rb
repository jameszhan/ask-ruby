module MongoidExt
  module Taggable
    extend ActiveSupport::Concern
  
    included do
      class_eval do
        field :tags, :type => Array, :default => []
        index :tags => 1
      end
    end  
  
    module ClassMethods  
      # Model.find_with_tags("budget", "big").limit(6)
      def find_with_tags(*tags)
        self.where({:tags.in => tags})
      end  
    end
  
  end
end


