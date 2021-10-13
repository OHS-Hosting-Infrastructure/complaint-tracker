require "rails_helper"
require "fake_issues"

RSpec.feature "Grantee", type: :feature do
  let(:user) {
    {
      name: "Request Spec",
      uid: "request.spec@test.com"
    }.with_indifferent_access
  }

  before do
    # There are some other session requests before getting to session["user"]
    allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
    allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
  end

  let!(:grantee) { Grantee.new(FakeIssues.instance.json[:data].first) }

  context "details page", js: true do
    before do
      visit "grantees/#{grantee.id}"
    end

    it "has details" do
      expect(page).to have_content "Grantee ##{grantee.id}"
    end
  end
end
