require 'spec_helper'

describe User do
  
  let(:username){ "James" }
  let(:email){ "zhiqiangzhan@gmail.com" }
  let(:uid){ "123556" }
  let(:provider) { "github" }
  
  let(:omniauth){
    Hashie::Mash.new(
      uid: uid, 
      provider: provider, 
      info: {
        nickname: username
      }
    )
  }
  
  let(:omniauth_with_email){
    omniauth.merge(uid: "111111", info: {email: email})
  }
  context "Save user to database." do       
    it "new user" do
      auth = Authentication.where(omniauth.slice(:uid, :provider)).each { |auth| auth.user.try(:destroy) }
      expect {
        User.from_omniauth(omniauth)          
      }.to change(User, :count).by(1)   
    end
      
    it "existing user" do    
      user = User.from_omniauth(omniauth) 
      expect {
        user2 = User.from_omniauth(omniauth)
        user2.should == user
      }.to change(User, :count).by(0)        
    end
  end

  context 'check user necessary field' do
    let(:user) { User.from_omniauth(omniauth) }
    let(:user_with_email) { User.from_omniauth(omniauth_with_email) }
    
    it "check email" do
      user.email.should be_blank
      user_with_email.email.should == email
    end
  
    it "check username" do
      user.username.should == username
    end
    
    it "check authentications" do
      user.authentications.should_not be_empty
      user.authentications.detect{|auth| auth.uid.eql?(uid) && auth.provider.eql?(provider)}.should_not be_nil
    end

  end
  
end
