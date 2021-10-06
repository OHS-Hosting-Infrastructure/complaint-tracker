require "rails_helper"

RSpec.describe Api::FakeData::Tta do
  describe "ActivityReport" do
    let(:access_token) { HsesAccessToken.new }
    subject { Api::FakeData::Tta::ActivityReport.new(display_id: display_id, access_token: access_token) }

    describe "#request" do
      context "successful request" do
        let(:display_id) { "RO4-VQ-14661" }

        it "returns an activity report with the right display_id" do
          expect(subject.request[:body][:data][:attributes][:displayId]).to eq display_id
        end

        it "wraps the activity report in a detail wrapper" do
          expect(subject.request).to match({
            success: true,
            code: 200,
            body: {
              data: {
                id: String,
                type: "activityReports",
                attributes: Hash,
                links: Hash
              }
            }
          })
        end
      end

      context "401 error" do
        let(:display_id) { "R01-AR-401" }

        it "returns the error message and metadata" do
          expect(subject.request).to match({
            success: false,
            code: 401,
            body: {
              status: "401",
              title: "Unauthenticated User",
              detail: "User token is missing or did not map to a known user"
            }
          })
        end
      end

      context "403 error" do
        let(:display_id) { "R01-AR-403" }

        it "returns the error message and metadata" do
          expect(subject.request).to match({
            success: false,
            code: 403,
            body: {
              status: "403",
              title: "Unauthorized User",
              details: "User does not have the appropriate permissions to view this resource"
            }
          })
        end
      end

      context "404 error" do
        let(:display_id) { "R01-AR-404" }

        it "returns the error message and metadata" do
          expect(subject.request).to match({
            success: false,
            code: 404,
            body: {
              status: "404",
              title: "Not Found",
              details: "Report #{display_id} could not be found"
            }
          })
        end
      end
    end
  end
end
