require "rails_helper"

RSpec.describe Grantee, type: :model do
  let(:id) { "fake-grantee-456" }
  let(:hses_link) { "https://example.com/html/TODO" }
  let(:hses_grantee) { Api::FakeData::Grantee.new(id: id).data }

  describe "initialize" do
    subject { described_class.new(hses_grantee: hses_grantee) }
    it "sets @id" do
      expect(subject.id).to eq hses_grantee[:id]
    end

    it "sets @attributes" do
      expect(subject.attributes).to eq hses_grantee[:attributes].with_indifferent_access
    end
  end

  # TODO: test for missing attribute
  context "with all the attributes" do
    subject { described_class.new(hses_grantee: hses_grantee) }
    describe "#name" do
      it "delegates to the attributes" do
        expect(subject.name).to eq hses_grantee[:attributes][:name]
      end
    end

    # TODO: test for missing attribute
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
  end

  context "with missing attributes" do
    let(:grantee_hash) do
      {
        id: "fake-grantee-1243",
        attributes: {}
      }
    end
    subject { described_class.new(hses_grantee: grantee_hash) }

    describe "#name" do
      it "delegates to the attributes" do
        expect(subject.name).to be nil
      end
    end

    # TODO: test for missing attribute
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
  end

  # TODO: test for missing attribute
  describe "#hses_link" do
    it "delegates to the attributes" do
      expect(subject.hses_link).to eq hses_link
    end
  end
end
