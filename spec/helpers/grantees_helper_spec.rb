require "rails_helper"

RSpec.describe GranteesHelper, type: :helper do
  describe "#name" do
    describe "the grantee's name" do
      let(:grantee) { {name: "My Grantee"} }

      it "returns the name of the grantee" do
        expect(name(grantee)).to eq "My Grantee"
      end
    end
  end
end
