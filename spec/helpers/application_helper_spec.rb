require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#current_user" do
    session_user = {
      name: "Test User",
      email: "testuser@example.com"
    }

    it "returns the username" do
      session["user"] = session_user
      expect(helper.current_user).to eq session_user.with_indifferent_access
    end
  end

  describe "#user_signed_in?" do
    it "returns true when username is set" do
      assign :current_user, "Test User"
      expect(helper.user_signed_in?).to be true
    end

    it "returns false when username is nil" do
      expect(helper.user_signed_in?).to be false
    end
  end
end
