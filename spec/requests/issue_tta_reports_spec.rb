require "rails_helper"
require "fake_issues"
require "api_delegator"

RSpec.describe "IssueTtaReports", type: :request do
  let(:complaint_id) { FakeIssues.instance.json[:data].first[:id] }
  let(:tta_display_id) { "RO4-VQ-14661" }
  let(:user) {
    {
      name: "Request Spec",
      uid: "request.spec@test.com"
    }.with_indifferent_access
  }
  let(:activity_report) { Api::FakeData::Tta::ActivityReport.new(display_id: tta_display_id) }

  describe "POST /issue_tta_reports" do
    context "user is not logged in" do
      it "redirects to root" do
        post issue_tta_reports_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end

    context "with an authorized user" do
      before do
        # There are some other session requests before getting to session["user"]
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
      end

      it "sends an API request to the tta system" do
        expect(ApiDelegator).to receive(:use)
          .with("tta", "activity_report", {display_id: tta_display_id})
          .and_return activity_report
        post issue_tta_reports_path,
          params: {tta_report_display_id: tta_display_id, issue_id: complaint_id}
      end

      it "adds an IssueTtaReport object" do
        expect {
          post issue_tta_reports_path,
            params: {tta_report_display_id: tta_display_id, issue_id: complaint_id}
        }.to change { IssueTtaReport.count }.by 1
      end
    end
  end

  describe "PUT /issue_tta_report/ID" do
    let(:issue_tta_report) {
      IssueTtaReport.create(
        issue_id: complaint_id,
        tta_report_display_id: tta_display_id,
        tta_report_id: "12345"
      )
    }

    context "user is not logged in" do
      it "redirects to root" do
        put issue_tta_report_path(issue_tta_report)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end

    context "with an authorized user" do
      before do
        # There are some other session requests before getting to session["user"]
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
      end

      it "sends an API request to the tta system" do
        expect(ApiDelegator).to receive(:use)
          .with("tta", "activity_report", {display_id: tta_display_id})
          .and_return activity_report
        post issue_tta_reports_path, params: {tta_report_display_id: tta_display_id, issue_id: complaint_id}
      end

      it "updates the IssueTtaReport object" do
        put issue_tta_report_path(issue_tta_report),
          params: {tta_report_display_id: "new_display_id", issue_id: complaint_id}

        updated_report = IssueTtaReport.find(issue_tta_report.id)
        expect(updated_report.tta_report_display_id).to eq "new_display_id"
      end
    end
  end
end
