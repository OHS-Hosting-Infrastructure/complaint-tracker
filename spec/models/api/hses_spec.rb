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
    context "with params argument" do
      let(:issues) {
        Api::Hses::Issues.new(
          user: user,
          params: ActionController::Parameters.new({page: "2"})
        )
      }

      describe "#initialize" do
        it "sets @username" do
          expect(issues.instance_variable_get(:@username)).to eq user["uid"]
        end
        it "sets @page" do
          expect(issues.instance_variable_get(:@page)).to eq "2"
        end
      end

      describe "#request" do
        it "sends query parameters with correct offset for pagination" do
          # stub the net/http request / response
          response = Net::HTTPSuccess.new(1.0, "200", "OK")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).and_return('{"meta":{},"data":[]}')

          expect(URI).to receive(:encode_www_form).with(
            {
              types: 1,
              username: "test.uid",
              offset: 25,
              limit: 25
            }
          )
          issues.request
        end
      end
    end

    context "without params argument" do
      let(:issues) { Api::Hses::Issues.new(user: user) }

      describe "#initialize" do
        it "sets @username" do
          expect(issues.instance_variable_get(:@username)).to eq user["uid"]
        end
        it "sets @page to default value" do
          expect(issues.instance_variable_get(:@page)).to eq 1
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
        it "sends query parameters for type, username, and pagination" do
          # stub the net/http request / response
          response = Net::HTTPSuccess.new(1.0, "200", "OK")
          expect_any_instance_of(Net::HTTP).to receive(:start).and_return response
          expect(response).to receive(:body).and_return('{"meta":{},"data":[]}')

          expect(URI).to receive(:encode_www_form).with(
            {
              types: 1,
              username: "test.uid",
              offset: 0,
              limit: 25
            }
          )
          issues.request
        end
      end
    end
  end
end
