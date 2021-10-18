require "rails_helper"

RSpec.describe ComplaintsHelper, type: :helper do
  describe "#page_link" do
    context "when the link is not the current page" do
      it "returns link without aria-current or usa-current class" do
        @pagy = Pagy.new(count: 26, page: 2)
        expect(page_link(1)).to eq '<a class="usa-pagination__button" aria-label="Page 1" href="/complaints?page=1">1</a>'
      end
    end

    context "when the link is the current page" do
      it "returns link with aria-current and usa-current class" do
        @pagy = Pagy.new(count: 26, page: 2)
        expect(page_link(2, current: true)).to eq '<a class="usa-pagination__button usa-current" aria-label="Page 2" aria-current="page" href="/complaints?page=2">2</a>'
      end
    end

    context "when the link is the last page" do
      it "aria-label includes 'Last page'" do
        @page_total = 5
        @pagy = Pagy.new(count: 101, page: 1)
        expect(page_link(5)).to eq '<a class="usa-pagination__button" aria-label="Last page, page 5" href="/complaints?page=5">5</a>'
      end
    end
  end

  describe "#status" do
    describe "a complaint that is less than a week old" do
      let(:complaint) { {status: {id: 0}, creationDate: 1.day.ago} }

      describe "an open complaint" do
        it "returns 'New' as the formatted status" do
          expect(status(complaint)).to eq "New"
        end
      end

      describe "a complaint that is not open" do
        it "returns the formatted status of the complaint's status " do
          complaint[:status] = {id: 3}
          expect(status(complaint)).to eq ComplaintsHelper::FORMATTED_STATUS[3]
        end
      end
    end

    describe "a complaint that is more than a week old" do
      let(:complaint) { {status: {id: 0}, creationDate: 1.month.ago} }

      describe "an open complaint" do
        it "returns 'In Progress' as the formatted status" do
          expect(status(complaint)).to eq "In Progress"
        end
      end

      describe "a complaint that is not open" do
        it "returns the formatted status of the complaint's status " do
          complaint[:status] = {id: 2}
          expect(status(complaint)).to eq ComplaintsHelper::FORMATTED_STATUS[2]
        end
      end
    end
  end
end
