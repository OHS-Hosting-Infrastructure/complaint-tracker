require "rails_helper"

RSpec.describe Grantee, type: :model do
  let(:hses_grantee) { Api::FakeData::Grantee.new.data }
  subject { described_class.new hses_grantee }

  before do
    hses_grantee[:attributes].merge!({
    })
  end

  describe "initialize" do
    it "sets @id" do
      expect(subject.id).to eq hses_grantee[:id]
    end

    it "sets @attributes" do
      expect(subject.attributes).to eq hses_grantee[:attributes].with_indifferent_access
    end
  end

  describe "#name" do
    it "deletages to the attributes" do
      expect(subject.name).to eq hses_grantee[:attributes][:name]
    end
  end

  describe "#region" do
    it "deletages to the attributes" do
      expect(subject.region).to eq hses_grantee[:attributes][:region]
    end
  end
end