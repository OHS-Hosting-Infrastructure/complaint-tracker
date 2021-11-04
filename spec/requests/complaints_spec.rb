require "rails_helper"
require "fake_issues"

RSpec.describe "Complaints", type: :request do
  let(:user) {
    {
      name: "Test User",
      uid: "testuser@example.com"
    }.with_indifferent_access
  }

  describe "GET /complaints" do
    describe "without an authorized user" do
      around do |example|
        Rails.configuration.x.bypass_auth = false
        example.run
        Rails.configuration.x.bypass_auth = true
      end

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
        expect(response.body).to include("You are now logged out of the complaints tracker.<br><em>Note: you may still be logged in to HSES</em>")
      end
    end

    describe "with an authorized user" do
      it "returns a 200 status" do
        get complaints_path
        expect(response).to have_http_status(200)
      end

      it "includes the user's name" do
        get complaints_path
        expect(response.body).to include "Fake Test-User"
      end

      describe "User has a complaint" do
        let(:complaint) { Api::FakeData::Complaint.new }

        it "includes the alert" do
          allow_any_instance_of(ApiResponseCollection).to receive(:data).and_return [complaint.data]

          get complaints_path

          expect(response.body).to include '<table class="usa-table">'
        end
      end

      describe "User has no complaints" do
        it "includes the alert" do
          allow_any_instance_of(ApiResponseCollection).to receive(:data).and_return []
          get complaints_path
          expect(response.body).to include '<h3 class="usa-alert__heading">No issues found</h3>'
        end
      end

      describe "Error returned by HSES" do
        before do
          allow_any_instance_of(ApiResponseCollection).to receive(:data).and_return []
        end

        context "400 error" do
          it "includes the error but not the no complaints alert" do
            get complaints_path(error: "400")
            expect(response.body).to include '<h4 class="usa-alert__heading">Bad Request</h4>'
            expect(response.body).to include '<p class="usa-alert__text">We&#39;re currently unable to access complaint data. Please refresh the page, and if you still see a problem, check back again later.</p>'
            expect(response.body).not_to include '<h3 class="usa-alert__heading">No issues found</h3>'
          end
        end

        context "403 error" do
          it "includes the error but not the no complaints alert" do
            get complaints_path(error: "403")
            expect(response.body).to include '<h4 class="usa-alert__heading">Remote IP is not allowed</h4>'
            expect(response.body).to include '<p class="usa-alert__text">You do not have permission to view these complaints. Please contact your administrator for assistance.</p>'
            expect(response.body).not_to include '<h3 class="usa-alert__heading">No issues found</h3>'
          end
        end

        context "500 error" do
          it "includes the error but not the no complaints alert" do
            get complaints_path(error: "500")
            expect(response.body).to include '<h4 class="usa-alert__heading">Unexpected error</h4>'
            expect(response.body).to include '<p class="usa-alert__text">We&#39;re currently unable to access complaint data. Please refresh the page, and if you still see a problem, check back again later.</p>'
            expect(response.body).not_to include '<h3 class="usa-alert__heading">No issues found</h3>'
          end
        end
      end
    end
  end

  describe "GET /complaint/:id" do
    let(:complaint_id) { FakeIssues.instance.data.first[:id] }

    it "returns a 200 status" do
      get complaint_path(id: complaint_id)
      expect(response).to have_http_status(200)
    end
  end
end
