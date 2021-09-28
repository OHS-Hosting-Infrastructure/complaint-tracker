require "rails_helper"

RSpec.describe Api::Hses do
  let(:user) { {"uid" => "test.uid"} }

  describe "Issue" do
    let(:issue) { Api::Hses::Issue.new(id: 1) }

    describe "#initialize" do
      it "sets @id" do
        expect(issue.id).to eq(1)
      end
    end

    describe "#request" do
      it "returns a wrapper with data" do
        expect(issue.request[:data]).to be_a Hash
        expect(issue.request[:data][:type]).to eq "issues"
      end
    end
  end

  describe "Issues" do
    let(:issues) { Api::Hses::Issues.new(user: user) }

    describe "#initialize" do
      it "sets @username" do
        expect(issues.instance_variable_get(:@username)).to eq user["uid"]
      end
    end

    describe "#host" do
      it "returns the value set in the Api::Hses module" do
        expect(issues.host).to eq Rails.configuration.x.hses.api_hostname
      end
    end

    describe "#request" do
      it "returns a Ruby object with meta and data keys" do
        # stub the net/http request / response
        response = Net::HTTPSuccess.new(1.0, "200", "OK")
        expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
        expect(response).to receive(:body).and_return('{"meta":{},"data":[]}')

        expect(issues.request).to match({"meta" => {}, "data" => []})
      end
    end
  end
end
