require 'spec_helper'

describe "Questions Detail page" do
	before do
		User.delete_all
    Question.delete_all
    @user1 = User.create username: 'name1', password: "secert12", email: "mlx@gmail.com", uid: "123456", provider: "github"
    @q1 = Question.create title: "who are you ?", body: "who are you ?", user: @user1, views_count: 2, votes_count: 2, answers_count: 1 
  	@q2 = Question.create title: "where are you come from ?", body: "where are you come from ?", user: @user1, views_count: 2, votes_count: 1, answers_count: 1
  end

  it "guest click question title should visit question detail" do
  	visit questions_path

  	page.should have_content @q1.title

  	click_link @q1.title

  	page.should have_content @q1.title
  	page.should_not have_content @q2.title
  end
end