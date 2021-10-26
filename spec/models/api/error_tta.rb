require "rails_helper"

RSpec.describe Api::ErrorTta do
  describe "initialize" do
    it "sets code and title" do
      error = Api::ErrorTta.new(400, {})

      expect(error.code).to eq 400
      expect(error.title).to eq "Bad Request"
    end
  end

  context "TTA style response" do
    it "returns code, title, and details" do
      fake_api_res = {
        status: 403,
        title: "TTA Bad Request",
        details: "TTA message"
      }
      error = Api::ErrorTta.new(403, fake_api_res)

      expect(error.code).to eq 403
      expect(error.title).to eq "TTA Bad Request"
      expect(error.details).to eq "You do not have permission to access this activity report."
    end
  end
end
