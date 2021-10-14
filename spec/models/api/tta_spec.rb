require "rails_helper"

RSpec.describe Api::Tta do
  let(:display_id) { "R01-AR-9999" }
  let(:access_token) { HsesAccessToken.new }

  describe "ActivityReport" do
    subject { Api::Tta::ActivityReport.new display_id: display_id, access_token: access_token }

    describe "#request" do
      context "successful response" do
        let(:response_data) do
          {data: {
            grantee: "Some Grantee"
          }}
        end

        before do
          # stub the net/http request / response
          response = Net::HTTPSuccess.new(1.1, "200", "OK")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).and_return(JSON.generate(response_data))
        end

        it "has a 200 code" do
          expect(subject.request.code).to be 200
        end

        it "returns the data" do
          expect(subject.request.data).to eq response_data[:data].with_indifferent_access
        end

        it "indicates it has not failed" do
          expect(subject.request.failed?).to be false
        end
      end

      context "404 error" do
        before do
          # stub the net/http request / response
          response = Net::HTTPNotFound.new(1.1, "404", "Not Found")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).and_return('{"status":"404", "title":"Not Found", "detail":""}')
        end

        it "returns an empty hash as the body" do
          expect(subject.request.body).to eq({})
        end

        it "has a code of 500" do
          expect(subject.request.code).to eq 404
        end

        it "indicates it is a failure" do
          expect(subject.request.failed?).to be true
        end
      end

      context "500 error" do
        before do
          # stub the net/http request / response
          response = Net::HTTPNotFound.new(1.1, "500", "Internal Server Error")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).and_return("")
        end

        it "returns an empty hash as the body and data" do
          expect(subject.request.body).to eq({})
          expect(subject.request.data).to eq({})
        end

        it "has a code of 500" do
          expect(subject.request.code).to eq 500
        end

        it "indicates it is a failure" do
          expect(subject.request.failed?).to be true
        end
      end
    end
  end
end
