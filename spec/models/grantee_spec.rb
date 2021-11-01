require "rails_helper"

RSpec.describe Grantee, type: :model do
  let(:id) { "fake-grantee-456" }
  let(:hses_link) { "https://example.com/html/TODO" }
  let(:hses_grantee) { Api::FakeData::Grantee.new(id: id).data }
  let(:delegator) { double ApiDelegator }
  let(:response) { double ApiResponse }

  describe "initialize" do
    subject { described_class.new(id) }

    it "sets @id" do
      expect(subject.id).to eq hses_grantee[:id]
    end
  end

  context "with all the attributes" do
    subject { described_class.new(id) }

    before do
      expect(ApiDelegator).to receive(:use).with("hses", "grantee", {id: id}).and_return delegator
      expect(delegator).to receive(:request).and_return response
      expect(response).to receive(:data).and_return hses_grantee
    end

    describe "#name" do
      it "delegates to the attributes" do
        expect(subject.name).to eq hses_grantee[:attributes][:granteeName]
      end
    end

    describe "#region" do
      it "delegates to the attributes" do
        expect(subject.region).to eq hses_grantee[:attributes][:grants][0][:attributes][:region]
      end
    end

    describe "#centers" do
      it "adds up all the numberOfCenters in the grants" do
        most_recent_grant = hses_grantee[:attributes][:grants]
          .max_by { |grant| grant[:attributes][:grantProgramStartDate] }

        expect(subject.centers).to eq most_recent_grant[:attributes][:numberOfCenters]
      end
    end

    describe "#complaints_per_fy" do
      it "delegates to the attributes" do
        complaint_count = {
          2022 => 0,
          2021 => 0,
          2020 => 0
        }

        hses_grantee[:attributes][:grants].each do |grant|
          grant[:attributes][:totalComplaintsFiscalYear].each do |count|
            complaint_count[count[:fiscalYear]] += count[:totalComplaints]
          end
        end

        expect(subject.complaints_per_fy).to eq complaint_count
      end
    end

    describe "#current_grant" do
      it "returns the first grant in the sorted grants list" do
        most_recent_grant = hses_grantee[:attributes][:grants]
          .max_by { |grant| grant[:attributes][:grantProgramStartDate] }

        expect(subject.current_grant.id).to eq most_recent_grant[:id]
      end
    end

    describe "#hses_link" do
      it "delegates to the attributes" do
        expect(subject.hses_link).to eq hses_link
      end
    end
  end

  context "with missing attributes" do
    subject { described_class.new(id) }

    let(:grantee_hash) do
      {
        id: id,
        attributes: {
          grants: []
        }
      }
    end

    before do
      expect(ApiDelegator).to receive(:use).with("hses", "grantee", {id: id}).and_return delegator
      expect(delegator).to receive(:request).and_return response
      expect(response).to receive(:data).and_return grantee_hash
    end

    describe "#name" do
      it "returns nil" do
        expect(subject.name).to be nil
      end
    end

    describe "#region" do
      it "delegates to the attributes" do
        expect(subject.region).to be nil
      end
    end

    describe "#centers" do
      it "delegates to the attributes" do
        expect(subject.centers).to be nil
      end
    end

    describe "#complaints_per_fy" do
      it "delegates to the attributes" do
        expect(subject.complaints_per_fy).to eq({})
      end
    end

    describe "#hses_link" do
      it "delegates to the attributes" do
        expect(subject.hses_link).to be nil
      end
    end
  end

  context "with associations" do
    subject { described_class.new(id) }

    before do
      expect(ApiDelegator).to receive(:use).with("hses", "grantee", {id: id}).and_return delegator
      expect(delegator).to receive(:request).and_return response
      expect(response).to receive(:data).and_return hses_grantee
    end

    describe "complaints" do
      it "delegates to the relationships" do
        expect(subject.complaints.size).to eq 2
      end
    end
  end
end
