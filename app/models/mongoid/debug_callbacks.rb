module Mongoid
  module DebugCallbacks
    extend ActiveSupport::Concern
    
    included do
      after_initialize filter_debug(:after_initialize)
      after_build filter_debug(:after_build)
      before_validation filter_debug(:before_validation)
      after_validation filter_debug(:after_validation)
      before_create filter_debug(:before_create)
      around_create around_debug(:around_create)
      after_create filter_debug(:after_create)
      after_find filter_debug(:after_find)
      before_update filter_debug(:before_update)
      around_update around_debug(:around_update)
      after_update filter_debug(:after_update)
      before_upsert filter_debug(:before_upsert)
      around_upsert around_debug(:around_upsert)
      after_upsert filter_debug(:after_upsert)
      before_save filter_debug(:before_save)
      around_save around_debug(:around_save)
      after_save filter_debug(:after_save)
      before_destroy filter_debug(:before_destroy)
      around_destroy around_debug(:around_destroy)
      after_destroy filter_debug(:after_destroy)
    end
    
    module ClassMethods  
      def filter_debug(filter_name)
        -> (record) {
          puts "#{record} => #{filter_name}!"
          true
        }      
      end 
      
      def around_debug(filter_name)
        -> (record, block) {
          puts "#{record} => #{filter_name}:before"
          block.call 
          puts "#{record} => #{filter_name}:after"
          true
        }      
      end    
    end
    
  end  
end


