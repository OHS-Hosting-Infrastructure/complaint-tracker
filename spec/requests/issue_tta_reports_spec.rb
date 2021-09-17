require "rails_helper"
require "fake_issues"

RSpec.describe "IssueTtaReports", type: :request do
  describe "POST /issue_tta_reports" do
    context "user is not logged in" do
      it "redirects to root" do
        post issue_tta_reports_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end

    context "with an authorized user" do
      let(:complaint_id) { FakeIssues.instance.json[:data].first[:id] }
      let(:tta_display_id) { "RO4-VQ-14661" }
      let(:user) {
        {
          name: "Request Spec",
          uid: "request.spec@test.com"
        }.with_indifferent_access
      }
      let(:activity_data) { Api::FakeData::ActivityReport.new(display_id: tta_display_id).data }

      before do
        # There are some other session requests before getting to session["user"]
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
      end

      it "sends an API request to the tta system" do
        expect(Api).to receive(:request).with("tta", "activity_report", {display_id: tta_display_id}).and_return data: activity_data
        post issue_tta_reports_path, params: {tta_report_id: tta_display_id, issue_id: complaint_id}
      end

      it "adds an IssueTtaReport object" do
        expect {
          post issue_tta_reports_path,
            params: {tta_report_id: tta_display_id, issue_id: complaint_id}
        }.to change { IssueTtaReport.count }.by 1
      end
    end
  end
end
