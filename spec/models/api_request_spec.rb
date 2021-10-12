require "rails_helper"
require "fake_issues"

RSpec.describe ApiRequest do
  describe "#response" do
    it "is memoized" do
      api = ApiRequest.new
      expect(api).to receive(:get_response).once.and_return "value"
      expect(api.response).to eq api.response
    end

    describe "with valid host, path, and query" do
      before do
        @api = ApiRequest.new
        # stub the Net::HTTP request / response
        success = Net::HTTPSuccess.new(1.0, "200", "OK")
        expect_any_instance_of(Net::HTTP)
          .to receive(:start)
          .and_return(success)
        expect(success).to receive(:body).and_return('{"meta":{},"data":[]}')

        # mock in host, path, and parameters
        allow(@api).to receive(:host).and_return "example.com"
        allow(@api).to receive(:path).and_return "/path"
      end
      it "returns an object with a code and a body" do
        allow(@api).to receive(:parameters).and_return []
        res = @api.response
        expect(res).to match({code: "200", body: {"meta" => {}, "data" => []}})
      end

      it "correctly encodes the query parameters" do
        allow(@api)
          .to receive(:parameters)
          .and_return({one: 1, two: ["a", "b"]})
        expect(URI::HTTPS)
          .to receive(:build)
          .with({
            host: "example.com",
            path: "/path",
            query: "one=1&two=a&two=b"
          }).and_call_original
        @api.response
      end
    end

    describe "without combinations of host, path, and parameters" do
      it "returns an error for missing host" do
        # mock in path and parameters
        allow_any_instance_of(ApiRequest).to receive(:path).and_return "/path"
        allow_any_instance_of(ApiRequest).to receive(:parameters).and_return []
        expect { ApiRequest.new.response }.to raise_error(RuntimeError)
      end
      it "returns an error for missing path" do
        # mock in path and parameters
        allow_any_instance_of(ApiRequest).to receive(:host).and_return "example.com"
        allow_any_instance_of(ApiRequest).to receive(:parameters).and_return []
        expect { ApiRequest.new.response }.to raise_error(RuntimeError)
      end
      it "returns an error for missing query" do
        # mock in path and parameters
        allow_any_instance_of(ApiRequest).to receive(:host).and_return "example.com"
        allow_any_instance_of(ApiRequest).to receive(:path).and_return "/path"
        expect { ApiRequest.new.response }.to raise_error(RuntimeError)
      end
    end
  end
end
