require "spec_helper"

describe NotificationsController do
  describe "routing" do

    it "routes to #index" do
      get("/notifications").should route_to("notifications#index")
    end

    it "routes to #destroy" do
      delete("/notifications/1").should route_to("notifications#destroy", :id => "1")
    end

  end
end
