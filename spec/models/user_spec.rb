require 'spec_helper'

describe User do
  it { validate_presence_of(:username)}
  it { validate_uniqueness_of(:username)}
  it { validate_presence_of(:authentications) }

  
  let(:omniauth){
    Hashie::Mash.new(
      uid: "123356", 
      provider: "github", 
      info: {
        nickname: "James", 
        email: "zhiqiangzhan@gmail.com"
      }
    )
  }

  let(:omniauth_without_email){
    omniauth.merge(info: {email: nil})
  }
  
  context 'new user with full info' do
    let(:user) { User.from_omniauth(omniauth) }
    
    it "add user info from omniauth" do
      user.authentications.should_not be_empty
      user.email.should_not be_blank
      user.persisted?.should be_true      
    end

    it "new user from omniauth" do
      expect {
        user     
      }.to change(User, :count).by(1)   
    end
  end

  context 'new user without email' do
    let(:otheruser) { User.from_omniauth(omniauth_without_email) }
    
    it "without email" do
      otheruser.authentications.should_not be_empty
      otheruser.email.should be_blank
      otheruser.persisted?.should be_true
    end

    it "new user from omniauth without email" do
      expect {
        otheruser          
      }.to change(User, :count).by(1)   
    end

  end
  
  context " User cann't save repeat " do 
    it "existing user" do  
      expect {
        user1 = User.from_omniauth(omniauth)
        user2 = User.from_omniauth(omniauth)
        user2.should == user1
      }.to change(User, :count).by(1)        
    end
  end  
end
