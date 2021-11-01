require "rails_helper"

RSpec.describe Api::FakeData::Grantee do
  describe "Grantee" do
    let(:id) { "fake-grantee-14661" }
    subject { Api::FakeData::Grantee.new(id: id) }

    describe "data" do
      it "the id is accessible" do
        expect(subject.data[:id]).to eq id
      end

      it "is the same every time" do
        expect(subject.data).to eq subject.data
      end
    end
  end
end
