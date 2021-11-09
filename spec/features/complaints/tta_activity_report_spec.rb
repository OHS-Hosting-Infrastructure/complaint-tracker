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

  let!(:complaint) { Complaint.new(FakeIssues.instance.data.first) }

  context "the complaint does not have an associated TTA report", js: true do
    before do
      visit "complaints/#{complaint.id}"
    end

    it "can link a TTA activity report" do
      click_button "Link TTA Activity Report"
      fill_in "TTA report display ID", with: test_display_id
      click_button "tta-report-create-link"

      expect(page).to have_content test_display_id
    end

    context "cancel linking a TTA activity report" do
      it "the assocation will not be created" do
        click_button "Link TTA Activity Report"
        fill_in "TTA report display ID", with: test_display_id
        click_button "js-close-tta-form"

        page.find("#tta-activity-form.display-none")
        expect(page).to_not have_content test_display_id
      end
    end

    context "error handling" do
      # In this context, this shared before block fills in the page and clicks submit.
      # Each sub-context defines a `test_display_id` that is used to trigger each individual error message
      # and verifies that it is seen
      before do
        click_button "Link TTA Activity Report"
        fill_in "TTA report display ID", with: test_display_id
        click_button "tta-report-create-link"
      end

      context "unauthorized user" do
        let(:test_display_id) { "R01-AR-403" }

        it "displays an appropriate error message" do
          expect(page).to have_content "You do not have permission to access this activity report."
        end
      end

      context "missing report" do
        let(:test_display_id) { "R01-AR-404" }

        it "displays an appropriate error message" do
          expect(page).to have_content "This number doesn't match any existing activity reports. Please double-check the number."
        end
      end

      context "generic connection issue" do
        let(:test_display_id) { "R01-AR-401" }

        it "displays an appropriate error message" do
          expect(page).to have_content "We're unable to look up reports in TTA Smart Hub right now. Please try again later."
        end
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

        find_button("Edit Activity Report Display ID").click
        page.find("##{test_display_id}").fill_in with: "R02-AR-14532"
        click_button "Save"

        expect(page).to_not have_content "TTA Activity:\n#{test_display_id}\n"
      end

      it "can cancel out of editing a TTA activity report display id" do
        expect(page).to have_content "TTA Activity:\n#{test_display_id}\n"
        find_button("Edit Activity Report Display ID").click
        page.find("##{test_display_id}").fill_in with: "RO2-AR-14532"
        page.find("#edit-tta-activity-#{issue_tta_report.id} .js-close-edit-link").click

        expect(page).to have_content "TTA Activity:\n#{test_display_id}\n"
      end
    end

    it "can unlink a TTA activity report display id" do
      expect(page).to have_content "TTA Activity:\n#{test_display_id}\n"
      page.find("#tta-activity-show-#{issue_tta_report.id} .js-open-unlink-modal").click
      click_button "tta-unlink-submit"

      expect(page).to_not have_content "TTA Activity:\n#{test_display_id}\n"
    end
  end
end
