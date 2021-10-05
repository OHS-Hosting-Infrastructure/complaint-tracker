require "rails_helper"
require "fake_issues"

RSpec.feature "Associating TTA Activity Report", type: :feature do
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
  let(:test_display_id) { "Test-Display-ID" }

  before do
    # There are some other session requests before getting to session["user"]
    allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
    allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
    allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("hses_access_token").and_return access_token_creds
  end

  let!(:complaint) { Complaint.new(FakeIssues.instance.json[:data].first) }

  context "the complaint does not have an associated TTA report", js: true do
    before do
      visit "complaints/#{complaint.id}"
    end

    it "can link a TTA activity report" do
      click_button "Link TTA Activity Report"
      fill_in "TTA report display ID", with: test_display_id
      click_button "Link"

      expect(page).to have_content test_display_id
    end

    context "cancel linking a TTA activity report" do
      it "the assocation will not be created" do
        click_button "Link TTA Activity Report"
        fill_in "TTA report display ID", with: test_display_id
        click_button "Cancel"

        page.find("#tta-activity-form.display-none")
        expect(page).to_not have_content test_display_id
      end
    end
  end

  context "the complaint has an associated TTA report", js: true do
    let!(:issue_tta_report) do
      IssueTtaReport.create(
        issue_id: complaint.id,
        tta_report_display_id: test_display_id,
        tta_report_id: "12345"
      )
    end

    before do
      visit "complaints/#{complaint.id}"
    end

    context "editing the associated report" do
      it "can successfully edit a TTA activity report display id" do
        expect(page).to have_content "TTA Activity:\n#{test_display_id}\n"

        find_button("Edit Display ID").click
        # fill_in "TTA report display ID", with: "RO2-AR-14532"
        page.find("##{test_display_id}").fill_in with: "RO2-AR-14532"
        click_button "Save"

        expect(page).to_not have_content "TTA Activity:\n#{test_display_id}\n"
      end

      it "can cancel out of editing a TTA activity report display id" do
        expect(page).to have_content "TTA Activity:\n#{test_display_id}\n"
        find_button("Edit Display ID").click
        page.find("##{test_display_id}").fill_in with: "RO2-AR-14532"
        page.find("#edit-tta-activity-#{test_display_id} .js-close-edit-tta").click

        expect(page).to have_content "TTA Activity:\n#{test_display_id}\n"
      end
    end

    it "can unlink a TTA activity report display id" do
      expect(page).to have_content "TTA Activity:\n#{test_display_id}\n"
      page.find("#tta-activity-show-#{test_display_id} .js-open-unlink-modal").click
      click_button "Yes, remove the link"

      expect(page).to_not have_content "TTA Activity:\n#{test_display_id}\n"
    end
  end
end
