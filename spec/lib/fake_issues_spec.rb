require "rails_helper"
require "fake_issues"

RSpec.describe FakeIssues do
  describe "different instances" do
    describe "#json" do
      it "the same json is returned" do
        first_instance = FakeIssues.instance
        second_instance = FakeIssues.instance

        expect(first_instance.json).to eq second_instance.json
      end
    end
  end
end
