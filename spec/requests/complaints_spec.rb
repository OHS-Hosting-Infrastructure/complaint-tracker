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
        expect(response.body).to include("You are now logged out of the complaints tracker.<br><em>Note: you may still be logged in to HSES</em>")
      end
    end

    describe "with an authorized user" do
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
        let(:complaint) { Api::FakeData::Complaint.new }

        it "includes the alert" do
          allow_any_instance_of(Api::FakeData::Hses::Issues).to receive(:request).and_return data: [complaint.data]
          get complaints_path

          expect(response.body).to include '<table class="usa-table" aria-describedby="#caption" >'
        end
      end

      describe "User has no complaints" do
        it "includes the alert" do
          allow_any_instance_of(Api::FakeData::Hses::Issues).to receive(:request).and_return data: []
          get complaints_path
          expect(response.body).to include user["name"].to_s
          expect(response.body).to include '<h3 class="usa-alert__heading">No issues found</h3>'
        end
      end
    end
  end

  describe "GET /complaint/:id" do
    context "with an authorized user" do
      before do
        # There are some other session requests before getting to session["user"]
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
      end

      let(:complaint_id) { FakeIssues.instance.json[:data].first[:id] }

      it "returns a 200 status" do
        get complaint_path(id: complaint_id)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /complaint/:id/unlink_tta_report" do
    context "with an authorized user" do
      before do
        # There are some other session requests before getting to session["user"]
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
      end

      let(:display_report_id) { "DisplayID " }
      let(:complaint_id) { FakeIssues.instance.json[:data].first[:id] }
      let!(:issue_tta_report) do
        IssueTtaReport.create(
          issue_id: complaint_id,
          tta_report_display_id: display_report_id,
          tta_report_id: "12345"
        )
      end

      it "redirects to the complaint path" do
        delete unlink_tta_report_path(id: complaint_id, tta_report_display_id: display_report_id)
        expect(response).to redirect_to action: :show, id: complaint_id
      end

      it "deletes the link" do
        delete unlink_tta_report_path(id: complaint_id, tta_report_display_id: display_report_id)
        expect { IssueTtaReport.find(issue_tta_report.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      describe "if a complaint has multiple TTA records" do
        let(:second_display_id) { "SecondDisplayId" }

        before do
          post issue_tta_reports_path,
            params: {tta_report_display_id: second_display_id, issue_id: complaint_id}
        end

        it "only deletes the specified tta_activity_report" do
          delete unlink_tta_report_path(id: complaint_id, tta_report_display_id: display_report_id)
          expect(IssueTtaReport.where(issue_id: complaint_id).count).to eq 1
        end
      end
    end
  end
end
