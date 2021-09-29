require "rails_helper"
require "api_delegator"

class Api::FakeData::Testsystem
  class Endpoint
    def initialize(*)
    end

    def request
      "test request"
    end
  end
end

class Api::Testsystem
  class Endpoint
    def initalize(*)
    end

    def request
      "real request"
    end
  end
end

RSpec.describe ApiDelegator do
  describe "in a testing environment" do
    describe "#self.request" do
      it "returns the test request" do
        api = ApiDelegator.use("testsystem", "endpoint")
        expect(api.request).to eq "test request"
      end
    end

    describe "self.namespaced_class" do
      it "returns the full class" do
        expect(
          ApiDelegator.namespaced_class("Testsystem", "Endpoint")
        ).to eq Api::FakeData::Testsystem::Endpoint
      end
    end
  end

  describe "when set to use real api data" do
    before do
      Rails.configuration.x.use_real_api_data = true
    end
    after do
      Rails.configuration.x.use_real_api_data = false
    end

    it "returns the real request" do
      api = ApiDelegator.use("testsystem", "endpoint")
      expect(api.request).to eq "real request"
    end

    describe "#self.namespaced_class" do
      it "returns the full class" do
        expect(
          ApiDelegator.namespaced_class("Testsystem", "Endpoint")
        ).to eq Api::Testsystem::Endpoint
      end
    end
  end
end
