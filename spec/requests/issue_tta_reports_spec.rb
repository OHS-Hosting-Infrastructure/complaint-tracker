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
  let(:access_token_creds) {
    {
      token: "access-token",
      refresh_token: "refresh-token",
      expires_at: 1.hour.from_now.to_i,
      expires: true
    }
  }
  let(:access_token) { HsesAccessToken.new(access_token_creds) }
  let(:activity_report) { Api::FakeData::Tta::ActivityReport.new(display_id: tta_display_id, access_token: access_token) }

  describe "POST /issue_tta_reports" do
    context "user is not logged in" do
      around do |example|
        Rails.configuration.x.bypass_auth = false
        example.run
        Rails.configuration.x.bypass_auth = true
      end

      it "redirects to root" do
        post issue_tta_reports_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end

    context "with an authorized user" do
      it "sends an API request to the tta system" do
        expect(ApiDelegator).to receive(:use)
          .with("tta", "activity_report", {display_id: tta_display_id, access_token: kind_of(HsesAccessToken)})
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
      around do |example|
        Rails.configuration.x.bypass_auth = false
        example.run
        Rails.configuration.x.bypass_auth = true
      end

      it "redirects to root" do
        put issue_tta_report_path(issue_tta_report)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end

    context "with an authorized user" do
      it "sends an API request to the tta system" do
        expect(ApiDelegator).to receive(:use)
          .with("tta", "activity_report", {display_id: tta_display_id, access_token: kind_of(HsesAccessToken)})
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

  describe "DELETE /issue_tta_report/unlink_report/:issue_id" do
    context "with an authorized user" do
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
        delete unlink_tta_report_path(issue_id: complaint_id, tta_report_display_id: display_report_id)
        expect(response).to redirect_to complaint_path(complaint_id)
      end

      it "deletes the link" do
        delete unlink_tta_report_path(issue_id: complaint_id, tta_report_display_id: display_report_id)
        expect { IssueTtaReport.find(issue_tta_report.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      describe "if a complaint has multiple TTA records" do
        let(:second_display_id) { "SecondDisplayId" }

        before do
          post issue_tta_reports_path,
            params: {tta_report_display_id: second_display_id, issue_id: complaint_id}
        end

        it "only deletes the specified tta_activity_report" do
          delete unlink_tta_report_path(issue_id: complaint_id, tta_report_display_id: display_report_id)
          expect(IssueTtaReport.where(issue_id: complaint_id).count).to eq 1
        end
      end
    end
  end
end
