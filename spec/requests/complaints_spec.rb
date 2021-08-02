require "rails_helper"

RSpec.describe "Complaints", type: :request do
  describe "GET /index" do
    it "returns a 200 status" do
      get root_path
      expect(response).to have_http_status(200)
    end

    describe "without an authorized user" do
      it "asks the user to log" do
        get root_path
        expect(response.body).to include("Please log in to access your complaints list")
      end
    end

    describe "with an authorized user" do
      before do
        user = {
          name: "Test User",
          email: "testuser@example.com"
        }.with_indifferent_access
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).and_return user
      end

      it "welcomes the user" do
        get root_path
        expect(response.body).to include("Test User's complaints")
      end
    end
  end
end
