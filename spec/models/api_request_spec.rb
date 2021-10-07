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
        allow_any_instance_of(ApiRequest).to receive(:parameters).and_return []

        res = ApiRequest.new.response
        expect(res).to match({code: "200", body: {"meta" => {}, "data" => []}})
      end

      it "is memoized" do
        api = ApiRequest.new
        expect(api).to receive(:get_response).once.and_return "value"
        expect(api.response).to eq api.response
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

    context "with differing pagination requests" do
      let(:api) { ApiRequest.new }

      before do
        success = Net::HTTPSuccess.new(1.0, "200", "OK")
        allow_any_instance_of(Net::HTTP)
          .to receive(:start)
          .and_return(success)
        expect(success)
          .to receive(:body)
          .and_return('{"meta":{},"data":[]}')

        # mock in host, path, and query
        allow_any_instance_of(ApiRequest).to receive(:host).and_return "example.com"
        allow_any_instance_of(ApiRequest).to receive(:path).and_return "/path"
        allow_any_instance_of(ApiRequest).to receive(:parameters).and_return []
      end

      it "returns no offset if no page is set" do
        api.response
        uri = api.instance_variable_get(:@uri)
        expect(uri.to_s).not_to include("page[offset]")
        expect(uri.to_s).not_to include("page[limit]")
      end
      it "returns the correct offset and limit if page is set to 1" do
        api.instance_variable_set(:@page, 1)
        api.response
        uri = api.instance_variable_get(:@uri)
        expect(uri.to_s).to include("page[offset]=0")
        expect(uri.to_s).to include("page[limit]=25")
      end
      it "returns the correct offset if page is set to 2" do
        api.instance_variable_set(:@page, 2)
        api.response
        uri = api.instance_variable_get(:@uri)
        expect(uri.to_s).to include("page[offset]=25")
      end
    end
  end
end
