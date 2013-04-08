# encoding: UTF-8
class User
  module OmniauthCallbacks
    extend ActiveSupport::Concern
    
    included do
      #has_many :authentications, :dependent => :destroy
      embeds_many :authentications
    end  

    module ClassMethods  
      @@validation = true
      def with_no_validation 
        @@validation = false
        yield
      ensure 
        @@validation = true
      end

      def from_omniauth(omniauth) 
        user = find_by_omniauth(omniauth).first
        unless user
          with_no_validation do
            user = create do |user|
              user.email = omniauth.info.email if omniauth.info.email
              user.password = Devise.friendly_token[0, 20]
              user.name = omniauth.info.nickname
              user.authentications.build(omniauth.slice(:provider, :uid))
            end  
          end
        end
        user.login_type = :omniauth
        user
      end

      def find_by_omniauth(omniauth)
        where(omniauth.slice(:provider, :uid).inject({}){|h, item| h.tap{h["authentications.#{item[0]}"] = item[1]}})
      end   
      
    end  
  end
end


