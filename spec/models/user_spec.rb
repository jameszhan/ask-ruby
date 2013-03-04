require 'spec_helper'

describe User do
  
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
  
  it "new user from omniauth" do
    user = User.from_omniauth(omniauth)  
    p user.authentications.first
    user.authentications should_not be_empty
  end
  
end
