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
        count = hses_grantee[:attributes][:grants].sum do |grant|
          grant[:attributes][:numberOfCenters]
        end

        expect(subject.centers).to eq count
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

    describe "#formatted_grant_ids" do
      it "returns a list of grant ids with a comma in between" do
        formatted_string = hses_grantee[:attributes][:grants]
          .map { |grant| grant[:id] }
          .join(", ")
        expect(subject.formatted_grant_ids).to eq formatted_string
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
        expect(subject.centers).to be 0
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
