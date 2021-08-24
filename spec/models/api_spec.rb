require "rails_helper"
require "fake_issues"

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

RSpec.describe Api do
  describe "in a testing environment" do
    describe "#self.request" do
      it "returns the test request" do
        result = Api.request("testsystem", "endpoint")
        expect(result).to eq "test request"
      end
    end

    describe "#self.env" do
      it "returns the FakeData string" do
        expect(Api.env).to eq "FakeData::"
      end
    end
  end

  describe "in a dev environment" do
    before do
      allow(Rails).to receive(:env).and_return("development")
    end

    describe "#self.request" do
      it "returns the test request" do
        result = Api.request("testsystem", "endpoint")
        expect(result).to eq "test request"
      end
    end

    describe "#self.env" do
      it "returns the FakeData string" do
        expect(Api.env).to eq "FakeData::"
      end
    end
  end

  describe "in a production environment" do
    before do
      allow(Rails).to receive(:env).and_return("production")
    end

    it "returns the real request" do
      result = Api.request("testsystem", "endpoint")
      expect(result).to eq "real request"
    end

    describe "#self.env" do
      it "returns nil" do
        expect(Api.env).to be nil
      end
    end
  end

  describe "in a staging environment" do
    before do
      allow(Rails).to receive(:env).and_return("staging")
    end

    it "returns the real request" do
      result = Api.request("testsystem", "endpoint")
      expect(result).to eq "real request"
    end

    describe "#self.env" do
      it "returns nil" do
        expect(Api.env).to be nil
      end
    end
  end
end
