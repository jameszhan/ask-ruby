require 'spec_helper'

describe "Questions page" do
  before do
    @current_node = Node.where(:name => "default").first_or_create

    @user1 = User.create! name: 'name1', password: "secert12", email: "mlx@gmail.com", uid: "123456", provider: "github"
  	@user2 = User.create! name: 'name2', password: "secert12", email: "mlx2@gmail.com", uid: "223456", provider: "github"

    @q1 = Question.create! title: "who are you ?", body: "who are you ?", node: @current_node, user: @user2, views_count: 2, votes_average: 2, answers_count: 1 
    @q2 = Question.create! title: "where are you come from ?", body: "where are you come from ?", node: @current_node, user: @user2, views_count: 2, votes_average: 1, answers_count: 1
    @q3 = Question.create! title: "where will you go ?", body: "where will you go ?", node: @current_node, user: @user1, views_count: 2, votes_average: 1, answers_count: 1
     
    visit '/questions'
  end

  context "guest can see questions list" do

    it "should display each question title ,author" do
      Question.all.each do |question|
      	page.should have_content question.title
        page.should have_content question.user.name
      end
    end

    it "should see each question's viewed times" do
      Question.all.each do |question|
        page.should have_content question.views_count
      end
    end

    it "should see each question's answers number" do
      Question.all.each do |question|
        page.should have_content question.answers_count
      end
    end

    it "should see each question's voted number" do
      Question.all.each do |question|
        page.should have_content question.votes_average
      end
    end

  end
end
