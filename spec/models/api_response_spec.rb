require "rails_helper"
require "fake_issues"

RSpec.describe ApiResponse do
  context "a successful response" do
    let(:params) { Net::HTTPSuccess.new(1.1, "200", "OK") }
    let(:response_body) do
      {
        data: {
          grantee: "Some Grantee"
        },
        meta: {
          itemTotalCount: 20
        }
      }
    end
    let(:subject) { ApiResponse.new(params) }

    before do
      expect(params).to receive(:body).and_return(JSON.generate(response_body))
    end

    describe "#initialize" do
      it "sets the response code" do
        expect(subject.code).to eq 200
      end
    end

    describe "#succeeded?" do
      it "returns true" do
        expect(subject.succeeded?).to be true
      end
    end

    describe "#failed?" do
      it "returns false" do
        expect(subject.failed?).to be false
      end
    end

    describe "#body" do
      it "returns the parsed body" do
        expect(subject.body).to eq response_body.with_indifferent_access
      end
    end

    describe "#data" do
      it "returns just the data part of the body" do
        expect(subject.data).to eq response_body[:data].with_indifferent_access
      end
    end
  end

  context "an unsuccessful response" do
    context "404 not found" do
      let(:params) { Net::HTTPNotFound.new(1.1, "404", "Not Found") }
      let(:subject) { ApiResponse.new(params) }

      before do
        expect(params).to receive(:body)
      end

      describe "#initialize" do
        it "sets the response code" do
          expect(subject.code).to eq 404
        end
      end

      describe "#succeeded?" do
        it "returns false" do
          expect(subject.succeeded?).to be false
        end
      end

      describe "#failed?" do
        it "returns true" do
          expect(subject.failed?).to be true
        end
      end

      describe "#body" do
        it "returns an empty hash" do
          expect(subject.body).to eq({})
        end
      end

      describe "#data" do
        it "returns an empty hash" do
          expect(subject.data).to eq({})
        end
      end
    end

    context "500 server error" do
      let(:params) { Net::HTTPNotFound.new(1.1, "500", "Internal Server Error") }
      let(:subject) { ApiResponse.new(params) }

      before do
        expect(params).to receive(:body)
      end

      describe "#initialize" do
        it "sets the response code" do
          expect(subject.code).to eq 500
        end
      end

      describe "#succeeded?" do
        it "returns false" do
          expect(subject.succeeded?).to be false
        end
      end

      describe "#failed?" do
        it "returns true" do
          expect(subject.failed?).to be true
        end
      end

      describe "#body" do
        it "returns an empty hash" do
          expect(subject.body).to eq({})
        end
      end

      describe "#data" do
        it "returns an empty hash" do
          expect(subject.data).to eq({})
        end
      end
    end
  end
end
