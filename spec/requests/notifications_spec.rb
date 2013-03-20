require 'spec_helper'

describe "Notifications" do
  describe "GET /notifications" do
  	before do
  		@user = User.create! name: 'name1', password: "secert12", email: "mlx@gmail.com", uid: "123456", provider: "github"
  	end
  	
  	before do
	    visit new_user_session_path

	    fill_in 'Email', with: @user.email 
	    fill_in 'Password', with: @user.password
	    click_button "Sign in"
	  end

    it "should visit /notifications" do
      visit notifications_path
      page.should have_content "Notifications"
    end
  end
end
