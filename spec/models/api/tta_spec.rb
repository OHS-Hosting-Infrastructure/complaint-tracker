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

        it "returns a Ruby object with a data key" do
          expect(subject.request).to match({data: {}})
        end
      end

      context "404 error" do
        before do
          # stub the net/http request / response
          response = Net::HTTPNotFound.new(1.1, "404", "Not Found")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).and_return('{"status":"404", "title":"Not Found", "detail":""}')
        end

        it "raises a RuntimeError" do
          expect { subject.request }.to raise_error(RuntimeError)
        end
      end
    end
  end
end
