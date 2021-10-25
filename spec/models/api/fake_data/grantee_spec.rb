require "rails_helper"

RSpec.describe Api::FakeData::Grantee do
  describe "Grantee" do
    let(:id) { "fake-grantee-14661" }
    let(:grantee) { Api::FakeData::Grantee.new(id: id) }

    describe "data" do
      it "the id is accessible" do
        expect(grantee.data[:id]).to eq id
      end

      it "is the same every time" do
        expect(grantee.data).to eq grantee.data
      end
    end
  end
end
