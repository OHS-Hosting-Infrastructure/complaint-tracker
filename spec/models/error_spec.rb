require "ostruct"
require "rails_helper"

RSpec.describe Api::Error do
  describe "#initialize" do
    it "sets status and title" do
      fake_api_res = OpenStruct.new(code: 400, body: '{"status": "400"}')
      error = Api::Error.new(ApiResponse.new(fake_api_res))
      expect(error.status).to eq 400
      expect(error.title).to eq "Bad Request"
    end
  end

  context "bad request" do
    context "HSES style response" do
      it "returns status, title, and details" do
        fake_api_res = OpenStruct.new(
          code: 400,
          body: '{"status": "400", "error": "Bad Request", "message": "HSES message"}'
        )
        error = Api::Error.new(ApiResponse.new(fake_api_res))
        expect(error.status).to eq 400
        expect(error.title).to eq "Bad Request"
        expect(error.details).to eq "HSES message"
      end
    end

    context "TTA style response" do
      it "returns status, title, and details" do
        fake_api_res = OpenStruct.new(
          code: 400,
          body: '{"status": 400, "title": "Bad Request", "details": "TTA message"}'
        )
        error = Api::Error.new(ApiResponse.new(fake_api_res))
        expect(error.status).to eq 400
        expect(error.title).to eq "Bad Request"
        expect(error.details).to eq "TTA message"
      end
    end
  end

  context "response with status but unexpected info structure" do
    it "returns status and default title and details" do
      fake_api_res = OpenStruct.new(
        code: 400,
        body: '{"data": {"some": "thing" }}'
      )
      error = Api::Error.new(ApiResponse.new(fake_api_res))
      expect(error.status).to eq 400
      expect(error.title).to eq "Bad Request"
      expect(error.details).to eq "Bad Request"
    end
  end
end
