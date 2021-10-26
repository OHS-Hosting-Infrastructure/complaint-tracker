require "rails_helper"

RSpec.describe Api::Error do
  describe "#initialize" do
    it "sets code and title" do
      error = Api::Error.new(400, {})

      expect(error.code).to eq 400
      expect(error.title).to eq "Bad Request"
    end
  end

  context "bad request" do
    context "essentially an HSES style response" do
      it "returns code, title, and details" do
        fake_api_res = {
          status: 400,
          error: "HSES Bad Request",
          message: "HSES message"
        }
        error = Api::Error.new(400, fake_api_res)

        expect(error.code).to eq 400
        expect(error.title).to eq "HSES Bad Request"
        expect(error.details).to eq "HSES message"
      end
    end
  end

  context "response with status code but unexpected info structure" do
    it "returns code and default title and details" do
      fake_api_res = {data: {}}
      error = Api::Error.new(400, fake_api_res)

      expect(error.code).to eq 400
      expect(error.title).to eq "Bad Request"
      expect(error.details).to eq "Bad Request"
    end
  end
end

RSpec.describe Api::ErrorTta do
  describe "initialize" do
    it "sets code and title" do
      error = Api::Error.new(400, {})

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
