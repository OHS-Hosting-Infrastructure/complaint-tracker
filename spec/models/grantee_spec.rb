require 'rails_helper'

RSpec.describe Grantee, type: :model do
  let(:hses_grantee) { Api::FakeData::Grantee.new.data }
  subject { described_class.new hses_grantee }

  let(:name) { 'Name of the Grantee' }

  before do
    hses_grantee[:attributes].merge!({
      name: name,
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

  describe "#grantee" do
    it "delegates to the attributes" do
      expect(subject.grantee).to eq hses_grantee[:attributes][:grantee]
    end
  end

  describe "#name?" do
    context "name is present" do
      it "returns true" do
        expect(subject.name?).to be true
      end
    end

    context "name is blank" do
      before { subject.attributes[:name] = nil }

      it "returns false" do
        expect(subject.name?).to be false
      end
    end
  end

  describe "#summary" do
    it "delegates to the attributes" do
      expect(subject.summary).to eq hses_grantee[:attributes][:summary]
    end
  end
end
