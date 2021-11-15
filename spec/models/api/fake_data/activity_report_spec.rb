require "rails_helper"

RSpec.describe Api::FakeData::ActivityReport do
  describe "ActivityReport" do
    let(:display_id) { "RO4-AR-14661" }
    let(:report) { Api::FakeData::ActivityReport.new(display_id: display_id) }

    describe "#init" do
      it "the display_id is accessible" do
        expect(report.display_id).to eq display_id
      end
    end

    describe "data" do
      it "has the display id as an attribute" do
        expect(report.data[:attributes][:displayId]).to eq display_id
      end

      it "is the same every time" do
        expect(report.data).to eq report.data
      end
    end
  end
end
