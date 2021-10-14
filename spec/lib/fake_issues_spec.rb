require "rails_helper"
require "fake_issues"

RSpec.describe FakeIssues do
  describe "different instances" do
    describe "#data" do
      it "the same data is returned" do
        first_instance = FakeIssues.instance
        second_instance = FakeIssues.instance

        expect(first_instance.data).to eq second_instance.data
      end
    end
  end
end
