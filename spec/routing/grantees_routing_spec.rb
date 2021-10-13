require "rails_helper"

RSpec.describe GranteesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/grantees").to route_to("grantees#index")
    end

    it "routes to #new" do
      expect(get: "/grantees/new").to route_to("grantees#new")
    end

    it "routes to #show" do
      expect(get: "/grantees/1").to route_to("grantees#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/grantees/1/edit").to route_to("grantees#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/grantees").to route_to("grantees#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/grantees/1").to route_to("grantees#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/grantees/1").to route_to("grantees#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/grantees/1").to route_to("grantees#destroy", id: "1")
    end
  end
end
