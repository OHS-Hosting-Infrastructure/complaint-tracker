require "rails_helper"

RSpec.describe Grant, type: :model do
  let(:id) { "fake-grant-456" }
  let(:grant_data) do
    Api::FakeData::Grantee.new(id: id).data[:attributes][:grants].first
  end

  subject { described_class.new(grant_data) }

  describe "#initialize" do
    it "sets @id" do
      expect(subject.id).to eq grant_data[:id]
    end
  end

  describe "#centers" do
    it "returns the attribute numberOfCenters" do
      expect(subject.centers).to eq grant_data[:attributes][:numberOfCenters]
    end
  end

  describe "#complaints_per_fiscal_year" do
    it "turns the array into a hash by year" do
      h = {
        2020 => grant_data[:attributes][:totalComplaintsFiscalYear][0][:totalComplaints],
        2022 => grant_data[:attributes][:totalComplaintsFiscalYear][1][:totalComplaints],
        2021 => grant_data[:attributes][:totalComplaintsFiscalYear][2][:totalComplaints]
      }

      expect(subject.complaints_per_fiscal_year).to eq h
    end
  end

  describe "#start_date" do
    it "returns the attribute program start date" do
      expect(subject.start_date).to eq grant_data[:attributes][:grantProgramStartDate]
    end
  end

  describe "#region" do
    it "returns the attribute region" do
      expect(subject.region).to eq grant_data[:attributes][:region]
    end
  end
end
