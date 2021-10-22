require "rails_helper"

RSpec.describe Api::Error do
  describe "#initialize" do
    it "sets code and title" do
      error = Api::Error.new(400, body: {})

      expect(error.code).to eq 400
      expect(error.title).to eq "Bad Request"
    end
  end

  context "bad request" do
    context "HSES style response" do
      it "returns code, title, and details" do
        fake_api_res = {status: 400, error: "HSES Bad Request", message: "HSES message"}
        error = Api::Error.new(400, body: fake_api_res)

        expect(error.code).to eq 400
        expect(error.title).to eq "HSES Bad Request"
        expect(error.details).to eq "HSES message"
      end
    end
  end

  context "response with status code but unexpected info structure" do
    it "returns code and default title and details" do
      fake_api_res = {data: {}}
      error = Api::Error.new(400, body: fake_api_res)

      expect(error.code).to eq 400
      expect(error.title).to eq "Bad Request"
      expect(error.details).to eq "Bad Request"
    end
  end
end

RSpec.describe Api::TtaError do
  describe "initialize" do
    it "sets code and title" do
      error = Api::Error.new(400, body: {})

      expect(error.code).to eq 400
      expect(error.title).to eq "Bad Request"
    end
  end

  context "TTA style response" do
    it "returns code, title, and details" do
      fake_api_res = {status: 400, title: "TTA Bad Request", details: "TTA message"}
      error = Api::TtaError.new(400, body: fake_api_res)

      expect(error.code).to eq 400
      expect(error.title).to eq "TTA Bad Request"
      expect(error.details).to eq "TTA message"
    end
  end
end
