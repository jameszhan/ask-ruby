require 'spec_helper'

describe Question do

  before do
  	@user = User.create username: 'name1', password: "secert12", email: "mlx@gmail.com", uid: "123456", provider: "github"
    @question = Question.create title: "who are you ?", body: "who are you ?", user: @user, views_count: 2, votes_count: 2, answers_count: 1 
  end
  
  subject { @question }

  it {should respond_to :title}
  it {should respond_to :body}
  it {should validate_presence_of :title}
  it {should respond_to :views_count}
  it {should respond_to :votes_count}
  it {should respond_to :answers_count}

  context "title" do
  	describe "should be invalid" do
  		before { @question.title = "122" }
   	  it {should_not be_valid}
  	end
  	describe "should be bevalid" do
  		before { @question.title = "a" * 101 }
   	  it {should_not be_valid}
  	end
  end
  
  context "body" do
  	describe "should be invalid" do
  		before { @question.body = "122" }
   	  it {should_not be_valid}
  	end
  	describe "should be valid" do
  		before { @question.body = "" }
   	  it {should be_valid}
  	end
  end

end
