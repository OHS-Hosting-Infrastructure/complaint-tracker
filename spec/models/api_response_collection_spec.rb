require "rails_helper"
require "fake_issues"

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
    end
  end
end
