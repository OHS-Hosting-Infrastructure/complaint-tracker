require "rails_helper"

RSpec.describe GranteesController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/grantees/1").to route_to("grantees#show", id: "1")
    end
  end
end
