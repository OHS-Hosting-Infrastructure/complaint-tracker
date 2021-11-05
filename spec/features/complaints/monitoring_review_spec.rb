require "rails_helper"
require "fake_issues"

RSpec.feature "Associating monitoring review", type: :feature do
  let(:user) {
    {
      name: "Request Spec",
      uid: "request.spec@test.com"
    }.with_indifferent_access
  }
  let(:test_id) { "Test-ID" }

  let!(:complaint) { Complaint.new(FakeIssues.instance.data.first) }

  context "the complaint does not have an associated IT-AMS review", js: true do
    before do
      visit "complaints/#{complaint.id}"
    end

    it "can link a monitoring review" do
      click_button "Link RAN Review"
      fill_in "monitoring-review-id", with: test_id
      click_button "monitoring-review-create-link"

      expect(page).to have_content test_id
    end

    context "cancel linking a monitoring review" do
      it "the assocation will not be created" do
        click_button "Link RAN Review"
        fill_in "RAN ID", with: test_id
        click_button "js-close-monitoring-form"

        page.find("#monitoring-activity-form.display-none")
        expect(page).to_not have_content test_id
      end
    end
  end

  context "the complaint has an associated monitoring review", js: true do
    let!(:issue_monitoring_review) do
      IssueMonitoringReview.create(
        issue_id: complaint.id,
        review_id: test_id
      )
    end

    before do
      visit "complaints/#{complaint.id}"
    end

    it "can unlink a monitoring review id" do
      expect(page).to have_content "RAN activity:\n#{test_id}\n"
      page.find("#monitoring-activity-show-#{issue_monitoring_review.id} .js-open-unlink-modal").click
      click_button "monitoring-unlink-submit"

      expect(page).to_not have_content "RAN Activity:\n#{test_id}\n"
    end
  end
end
