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
