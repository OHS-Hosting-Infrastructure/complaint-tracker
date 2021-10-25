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
        expect(subject.name).to eq hses_grantee[:attributes][:name]
      end
    end

    describe "#region" do
      it "delegates to the attributes" do
        expect(subject.region).to eq hses_grantee[:attributes][:region]
      end
    end

    describe "#centers_total" do
      it "delegates to the attributes" do
        expect(subject.centers_total).to eq hses_grantee[:attributes][:numberOfCenters]
      end
    end

    describe "#complaints_per_fy" do
      it "delegates to the attributes" do
        expect(subject.complaints_per_fy).to eq hses_grantee[:attributes][:totalComplaintsFiscalYear]
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
        attributes: {}
      }
    end

    before do
      expect(ApiDelegator).to receive(:use).with("hses", "grantee", {id: id}).and_return delegator
      expect(delegator).to receive(:request).and_return response
      expect(response).to receive(:data).and_return grantee_hash
    end

    describe "#name" do
      it "delegates to the attributes" do
        expect(subject.name).to be nil
      end
    end

    describe "#region" do
      it "delegates to the attributes" do
        expect(subject.region).to be nil
      end
    end

    describe "#centers_total" do
      it "delegates to the attributes" do
        expect(subject.centers_total).to be nil
      end
    end

    describe "#complaints_per_fy" do
      it "delegates to the attributes" do
        expect(subject.complaints_per_fy).to be nil
      end
    end

    describe "#hses_link" do
      it "delegates to the attributes" do
        expect(subject.hses_link).to be nil
      end
    end
  end
end
