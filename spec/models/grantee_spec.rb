require "rails_helper"

RSpec.describe Grantee, type: :model do
  let(:id) { "fake-grantee-456" }
  let(:hses_link) { "https://example.com/html/TODO" }
  let(:hses_grantee) { Api::FakeData::Grantee.new(id: id).data }
  subject { described_class.new(hses_grantee: hses_grantee) }

  describe "initialize" do
    it "sets @id" do
      expect(subject.id).to eq hses_grantee[:id]
    end

    it "sets @attributes" do
      expect(subject.attributes).to eq hses_grantee[:attributes].with_indifferent_access
    end
  end

  # TODO: test for missing attribute
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

  # TODO: test for missing attribute
  describe "#hses_link" do
    it "delegates to the attributes" do
      expect(subject.hses_link).to eq hses_link
    end
  end
end
