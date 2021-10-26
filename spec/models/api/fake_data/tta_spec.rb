require "rails_helper"

RSpec.describe Api::FakeData::Tta do
  describe "ActivityReport" do
    let(:access_token) { HsesAccessToken.new }
    subject { Api::FakeData::Tta::ActivityReport.new(display_id: display_id, access_token: access_token) }

    describe "#request" do
      context "successful request" do
        let(:display_id) { "RO4-VQ-14661" }

        it "returns an activity report with the right display_id" do
          expect(subject.request.data[:attributes][:displayId]).to eq display_id
        end

        it "wraps the activity report in a detail wrapper" do
          expect(subject.request.body).to match({
            data: {
              id: String,
              type: "activityReports",
              attributes: Hash,
              links: Hash
            }
          })
        end
      end

      context "401 error" do
        let(:display_id) { "R01-AR-401" }

        it "returns the error message and metadata" do
          response = subject.request
          expect(response).to be_failed
          expect(response.code).to eq 401
          expect(response.body).to match({
            status: "401",
            title: "Unauthenticated User",
            detail: "User token is missing or did not map to a known user"
          })
        end
      end

      context "403 error" do
        let(:display_id) { "R01-AR-403" }

        it "returns the error message and metadata" do
          response = subject.request
          expect(response).to be_failed
          expect(response.code).to eq 403
          expect(response.body).to match({
            status: "403",
            title: "Unauthorized User",
            details: "User does not have the appropriate permissions to view this resource"
          })
        end
      end

      context "404 error" do
        let(:display_id) { "R01-AR-404" }

        it "returns the error message and metadata" do
          response = subject.request
          expect(response).to be_failed
          expect(response.code).to eq 404
          expect(response.body).to match({
            status: "404",
            title: "Not Found",
            details: "Report #{display_id} could not be found"
          })
        end
      end

      context "500 error" do
        let(:display_id) { "R01-AR-500" }

        it "returns a blank body and metadata" do
          response = subject.request
          expect(response).to be_failed
          expect(response.code).to eq 500
          expect(response.body).to eq({})
        end
      end
    end
  end
end
