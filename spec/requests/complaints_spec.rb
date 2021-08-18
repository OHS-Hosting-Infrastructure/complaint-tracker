require "rails_helper"

RSpec.describe "Complaints", type: :request do
  describe "GET /complaints" do
    it "returns a 302 status" do
      get complaints_path
      expect(response).to have_http_status(302)
    end

    describe "without an authorized user" do
      it "asks the user to log" do
        get complaints_path
        follow_redirect!
        expect(response.body).to include("Please log in to access your complaints list")
      end
    end

    describe "on log out" do
      it "displays a message that user was logged out" do
        delete logout_path
        follow_redirect!
        expect(response.body).to include("You are now logged out")
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

      it "returns a 200 status" do
        get complaints_path
        expect(response).to have_http_status(200)
      end

      it "includes the user's name" do
        get complaints_path
        expect(response.body).to include user["name"].to_s
      end

      describe "User has a complaint" do
        let(:complaint) { FakeData::Complaint.new }

        it "includes the alert" do
          allow(FakeData::ApiResponse).to receive(:generate_hses_issues_response).and_return data: [complaint.data]
          get complaints_path

          expect(response.body).to include '<table class="usa-table">'
        end
      end

      describe "User has no complaints" do
        before { ComplaintsController.class_variable_set :@@hses_issues, [] }
        it "includes the alert" do
          allow(FakeData::ApiResponse).to receive(:generate_hses_issues_response).and_return data: []
          get complaints_path
          expect(response.body).to include user["name"].to_s
          expect(response.body).to include '<h3 class="usa-alert__heading">No issues found</h3>'
        end
      end
    end
  end
end
