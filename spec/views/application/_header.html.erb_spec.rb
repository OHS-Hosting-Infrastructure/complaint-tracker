require "rails_helper"

RSpec.describe "rendering header buttons do" do
  describe "with no authorized user logged in" do
    it "has a logout button" do
      render partial: "application/header.html.erb"

      expect(rendered).to match '<input class="usa-button usa-button--accent-warm" type="submit" value="Log in" />'
    end
  end

  describe "with an authorized user logged in" do
    let(:user) {
      {
        name: "Test User",
        uid: "testuser@example.com"
      }.with_indifferent_access
    }

    it "has a logout button" do
      session["user"] = user
      render partial: "application/header.html.erb"
      expect(rendered).to match '<input class="usa-button usa-button--accent-warm" data-turbolinks="false" type="submit" value="Log out" />'
    end
  end
end
