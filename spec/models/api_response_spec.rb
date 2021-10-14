require "rails_helper"
require "fake_issues"

RSpec.describe ApiResponse do
  context "a successful response" do
    let(:http_obj) { Net::HTTPSuccess.new(1.1, "200", "OK") }
    subject { ApiResponse.new(http_obj) }

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

    before do
      expect(http_obj).to receive(:body).and_return(JSON.generate(response_body))
    end

    describe "#initialize" do
      it "sets the response code" do
        expect(subject.code).to eq 200
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

    describe "#failed?" do
      it "returns false" do
        expect(subject.failed?).to be false
      end
    end

    describe "#succeeded?" do
      it "returns true" do
        expect(subject.succeeded?).to be true
      end
    end
  end

  context "an unsuccessful response" do
    context "404 not found" do
      let(:http_obj) { Net::HTTPNotFound.new(1.1, "404", "Not Found") }
      let(:subject) { ApiResponse.new(http_obj) }

      before do
        expect(http_obj).to receive(:body)
      end

      describe "#initialize" do
        it "sets the response code" do
          expect(subject.code).to eq 404
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

      describe "#failed?" do
        it "returns true" do
          expect(subject.failed?).to be true
        end
      end

      describe "#succeeded?" do
        it "returns false" do
          expect(subject.succeeded?).to be false
        end
      end
    end

    context "500 server error" do
      let(:http_obj) { Net::HTTPNotFound.new(1.1, "500", "Internal Server Error") }
      let(:subject) { ApiResponse.new(http_obj) }

      before do
        expect(http_obj).to receive(:body)
      end

      describe "#initialize" do
        it "sets the response code" do
          expect(subject.code).to eq 500
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

      describe "#failed?" do
        it "returns true" do
          expect(subject.failed?).to be true
        end
      end

      describe "#succeeded?" do
        it "returns false" do
          expect(subject.succeeded?).to be false
        end
      end
    end
  end
end

RSpec.describe ApiResponseCollection do
  context "a successful response with many responses" do
    let(:http_obj) { Net::HTTPSuccess.new(1.1, "200", "OK") }
    subject { ApiResponseCollection.new(http_obj) }

    let(:response_body) do
      {
        data: [
          {grantee: "Some grantee"},
          {grantee: "Some other grantee"}
        ],
        meta: {itemTotalCount: 76}
      }
    end

    before do
      expect(http_obj).to receive(:body).and_return(JSON.generate(response_body))
    end

    describe "#count" do
      it "gets the item total count" do
        expect(subject.count).to eq 76
      end
    end

    describe "#data" do
      it "gets the data" do
        expect(subject.data).to be_a Array
        expect(subject.data.first).to match({grantee: "Some grantee"})
      end
    end

    describe "#page_total" do
      it "calculates the total pages of results" do
        expect(subject.page_total).to eq 4
      end
    end
  end

  context "an unsuccessful response" do
    context "404 not found" do
      let(:http_obj) { Net::HTTPNotFound.new(1.1, "404", "Not Found") }
      let(:subject) { ApiResponseCollection.new(http_obj) }

      before do
        expect(http_obj).to receive(:body)
      end

      describe "#count" do
        it "returns 0" do
          expect(subject.count).to be 0
        end
      end

      describe "#data" do
        it "returns an empty array" do
          expect(subject.data).to eq([])
        end
      end

      describe "#page_total" do
        it "returns 0" do
          expect(subject.page_total).to be 0
        end
      end
    end

    context "500 server error" do
      let(:http_obj) { Net::HTTPNotFound.new(1.1, "500", "Internal Server Error") }
      let(:subject) { ApiResponseCollection.new(http_obj) }

      before do
        expect(http_obj).to receive(:body)
      end

      describe "#count" do
        it "returns zero" do
          expect(subject.count).to eq 0
        end
      end

      describe "#data" do
        it "returns an empty array" do
          expect(subject.data).to eq([])
        end
      end

      describe "#page_total" do
        it "returns 0" do
          expect(subject.page_total).to be 0
        end
      end
    end
  end
end
