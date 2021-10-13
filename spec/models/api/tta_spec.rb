require "rails_helper"

RSpec.describe Api::Tta do
  let(:display_id) { "R01-AR-9999" }
  let(:access_token) { HsesAccessToken.new }

  describe "ActivityReport" do
    subject { Api::Tta::ActivityReport.new display_id: display_id, access_token: access_token }

    describe "#request" do
      context "successful response" do
        before do
          # stub the net/http request / response
          response = Net::HTTPSuccess.new(1.1, "200", "OK")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).and_return('{"data":{}}')
        end

        it "returns a Ruby object with success, code, and body keys" do
          expect(subject.request).to match({
            success: true,
            code: 200,
            body: {data: {}}
          })
        end
      end

      context "404 error" do
        before do
          # stub the net/http request / response
          response = Net::HTTPNotFound.new(1.1, "404", "Not Found")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).and_return('{"status":"404", "title":"Not Found", "detail":""}')
        end

        it "returns the error message and metadata" do
          expect(subject.request).to match({
            success: false,
            code: 404,
            body: {
              status: "404",
              title: "Not Found",
              detail: ""
            }
          })
        end
      end

      context "500 error" do
        before do
          # stub the net/http request / response
          response = Net::HTTPNotFound.new(1.1, "500", "Internal Server Error")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).twice.and_return("")
        end

        it "returns the error message and metadata" do
          expect(subject.request).to match({
            success: false,
            code: 500,
            body: {}
          })
        end
      end
    end
  end
end
