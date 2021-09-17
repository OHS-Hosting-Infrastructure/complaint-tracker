require "rails_helper"

RSpec.describe Api::FakeData::Tta do
  describe "ActivityReport" do
    let(:display_id) { "RO4-VQ-14661" }

    describe "#request" do
      let(:issue_endpoint) { Api::FakeData::Tta::ActivityReport.new(display_id: display_id) }
      it "returns an activity report with the right display_id" do
        expect(issue_endpoint.request[:data][:attributes][:display_id]).to eq display_id
      end

      it "wraps the activity report in a detail wrapper" do
        expect(issue_endpoint.request.keys).to eq [:data]
      end
    end
  end
end
