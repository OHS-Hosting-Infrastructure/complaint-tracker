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
      let(:user) {
        {
          name: "Test User",
          uid: "testuser@example.com"
        }.with_indifferent_access
      }

      before do
        # There are some other session requests before getting to session["user"]
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
      end

      it "includes the user's name" do
        get root_path
        expect(response.body).to include user["name"].to_s
      end
    end
  end
end
