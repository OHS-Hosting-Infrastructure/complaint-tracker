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

  describe "in a dev environment" do
    before do
      allow(Rails).to receive(:env) { "development".inquiry }
    end

    describe "#self.request" do
      it "returns the test request" do
        api = ApiDelegator.use("testsystem", "endpoint")
        expect(api.request).to eq "test request"
      end
    end

    describe "#self.namespaced_class" do
      it "returns the full class" do
        expect(
          ApiDelegator.namespaced_class("Testsystem", "Endpoint")
        ).to eq Api::FakeData::Testsystem::Endpoint
      end
    end
  end

  describe "in a production environment" do
    before do
      allow(Rails).to receive(:env) { "production".inquiry }
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

  describe "in a staging environment" do
    before do
      allow(Rails).to receive(:env) { "staging".inquiry }
    end

    it "returns the real request" do
      api = ApiDelegator.use("testsystem", "endpoint")
      expect(api.request).to eq "real request"
    end

    it "returns the full class" do
      expect(
        ApiDelegator.namespaced_class("Testsystem", "Endpoint")
      ).to eq Api::Testsystem::Endpoint
    end
  end

  describe "in a ci environment" do
    before do
      allow(Rails).to receive(:env) { "ci".inquiry }
    end

    it "returns the test request" do
      api = ApiDelegator.use("testsystem", "endpoint")
      expect(api.request).to eq "test request"
    end

    it "returns the full class" do
      expect(
        ApiDelegator.namespaced_class("Testsystem", "Endpoint")
      ).to eq Api::FakeData::Testsystem::Endpoint
    end
  end
end
