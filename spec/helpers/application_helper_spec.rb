require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#current_user" do
    it "returns the username" do
      session["username"] = "Test User"
      expect(helper.current_user).to eq "Test User"
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
