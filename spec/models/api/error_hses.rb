require "rails_helper"

RSpec.describe Api::ErrorHses do
  context "HSES style response" do
    it "400 returns the overriding message correctly" do
      fake_api_res = {status: 400, error: "HSES Bad Request", message: "HSES message"}
      error = Api::ErrorHses.new(400, fake_api_res)

      expect(error.code).to eq 400
      expect(error.title).to eq "HSES Bad Request"
      expect(error.details).to eq "We're currently unable to access complaint data. Please refresh the page, and if you still see a problem, check back again later."
    end

    it "403 returns the overriding message correctly" do
      fake_api_res = {status: 403, error: "HSES Bad Request", message: "HSES message"}
      error = Api::ErrorHses.new(403, fake_api_res)

      expect(error.code).to eq 403
      expect(error.title).to eq "HSES Bad Request"
      expect(error.details).to eq "You do not have permission to view these complaints. Please contact your administrator for assistance."
    end
  end
end
