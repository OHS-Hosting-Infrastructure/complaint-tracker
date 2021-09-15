require "rails_helper"

RSpec.describe Api::Hses do
  let(:user) { {"uid" => "test.uid"} }

  describe "Issues" do
    describe "#initialize" do
      it "sets @username" do
        issues = Api::Hses::Issues.new(user: user)
        expect(issues.instance_variable_get(:@username)).to eq user["uid"]
      end
    end

    describe "#request" do
      let(:issues) { Api::Hses::Issues.new(user: user) }

      it "returns a Ruby object with meta and data keys" do
        # stub the net/http request / response
        response = Net::HTTPSuccess.new(1.0, "200", "OK")
        expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
        expect(response).to receive(:body).and_return('{"meta":{},"data":[]}')

        expect(issues.request).to eq({"meta" => {}, "data" => []})
      end
    end
  end
end
