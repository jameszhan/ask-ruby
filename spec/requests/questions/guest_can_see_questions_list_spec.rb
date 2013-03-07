require 'spec_helper'

describe "Questions page" do
  context "guest can see questions list" do
  	
  	before do
      User.delete_all
      Question.delete_all

      @user1 = User.create username: 'name1', password: "secert12", email: "mlx@gmail.com", uid: "123456", provider: "github"
  		@user2 = User.create username: 'name2', password: "secert12", email: "mlx2@gmail.com", uid: "223456", provider: "github"

      @q1 = Question.create title: "who are you ?", body: "who are you ?", user: @user2
  		@q2 = Question.create title: "where are you come from ?", body: "where are you come from ?", user: @user2
  		@q3 = Question.create title: "where will you go ?", body: "where will you go ?", user: @user1
  	end
    
    it "can visit questions should display questions list" do
      visit '/questions'

      Question.all.each do |question|
      	page.should have_content question.title
        page.should have_content question.user.username
      end
    end
  end
end
