require "rails_helper"
require "fake_issues"

RSpec.describe ApiRequest do
  describe "#response" do
    describe "with valid host, path, and query" do
      it "returns an object with a code and a body" do
        # stub the net/http request / response
        success = Net::HTTPSuccess.new(1.0, "200", "OK")
        allow_any_instance_of(ApiRequest)
          .to receive(:send_api_request)
          .and_return success
        expect(success).to receive(:body).and_return('{"meta":{},"data":[]}')
        # mock in host, path, and query
        allow_any_instance_of(ApiRequest).to receive(:host).and_return "example.com"
        allow_any_instance_of(ApiRequest).to receive(:path).and_return "/path"
        allow_any_instance_of(ApiRequest).to receive(:query).and_return "?some=query"

        res = ApiRequest.new.response
        expect(res).to match({code: "200", body: {"meta" => {}, "data" => []}})
      end
    end

    describe "without combinations of host, path, and query" do
      it "returns an error for missing host" do
        # mock in path and query
        allow_any_instance_of(ApiRequest).to receive(:path).and_return "/path"
        allow_any_instance_of(ApiRequest).to receive(:query).and_return "?some=query"
        expect { ApiRequest.new.response }.to raise_error(RuntimeError)
      end
      it "returns an error for missing path" do
        # mock in path and query
        allow_any_instance_of(ApiRequest).to receive(:host).and_return "example.com"
        allow_any_instance_of(ApiRequest).to receive(:query).and_return "?some=query"
        expect { ApiRequest.new.response }.to raise_error(RuntimeError)
      end
      it "returns an error for missing query" do
        # mock in path and query
        allow_any_instance_of(ApiRequest).to receive(:host).and_return "example.com"
        allow_any_instance_of(ApiRequest).to receive(:path).and_return "/path"
        expect { ApiRequest.new.response }.to raise_error(RuntimeError)
      end
    end
  end

  describe "#request_uri" do
    it "returns an error because of missing a host" do
      expect { ApiRequest.new.request_uri }.to raise_error(RuntimeError)
    end
  end
end
