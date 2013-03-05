require 'spec_helper'

describe User do
  
  before(:all) do
    DatabaseCleaner.start
  end
  
  before(:each) do
    DatabaseCleaner.clean
  end
  
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
  
  it "add user info from omniauth without email" do
     user = User.from_omniauth(omniauth_without_email) 
     user.persisted?.should be_true
     user.authentications.should_not be_empty
     user.username.should_not be_blank
     user.email.should be_blank
  end

  it "add user info from omniauth" do
    user = User.from_omniauth(omniauth)  
    user.persisted?.should be_true
    user.authentications.should_not be_empty
    user.username.should_not be_blank
    user.email.should_not be_blank      
  end
  
  it "new user from omniauth" do
    expect {
      user = User.from_omniauth(omniauth)          
    }.to change(User, :count).by(1)   
  end
    
  it "existing user from omniauth" do
    user = User.from_omniauth(omniauth) 
    expect {    
      user2 = User.from_omniauth(omniauth)
      user2.should == user
    }.to change(User, :count).by(0)        
  end
  
  
end
