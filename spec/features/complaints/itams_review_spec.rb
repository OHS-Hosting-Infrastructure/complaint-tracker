require "rails_helper"
require "fake_issues"

RSpec.feature "Associating IT-AMS Review", type: :feature do
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

    xit "can link an IT-AMS review" do
      click_button "Link RAN Review"
      fill_in "itams-review-id", with: test_id
      click_button "itams-review-create-link"

      expect(page).to have_content test_id
    end

    context "cancel linking an ITAMS review" do
      it "the assocation will not be created" do
        click_button "Link RAN Review"
        fill_in "RAN ID", with: test_id
        click_button "js-close-itams-form"

        page.find("#itams-activity-form.display-none")
        expect(page).to_not have_content test_id
      end
    end
  end
end
