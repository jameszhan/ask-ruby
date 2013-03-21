require "spec_helper"

describe AnswersController do
  describe "routing" do

    it "routes to #create" do
      post("/questions/1/answers").should route_to("answers#create", :question_id => "1" )
    end

    it "routes to #update" do
      put("/questions/1/answers/1").should route_to("answers#update", :id => "1", :question_id => "1")
    end

    it "routes to #destroy" do
      delete("/questions/1/answers/1").should route_to("answers#destroy", :id => "1", :question_id => "1")
    end

  end
end
