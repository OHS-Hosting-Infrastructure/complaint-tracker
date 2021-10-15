require "rails_helper"

RSpec.describe ComplaintsHelper, type: :helper do
  describe "#page_link" do
    context "when the link is not the current page" do
      it "returns link without aria-current or usa-current class" do
        expect(page_link(1, 2)).to eq '<a class="usa-pagination__button" aria-label="Page 1" href="/complaints?page=1">1</a>'
      end
    end

    context "when the link is the same as the current page" do
      it "returns link with aria-current and usa-current class" do
        expect(page_link(1, 1)).to eq '<a class="usa-pagination__button usa-current" aria-label="Page 1" aria-current="page" href="/complaints?page=1">1</a>'
      end
    end

    context "when the link is the last page" do
      it "aria-label includes 'Last page'" do
        @page_total = 5
        expect(page_link(5, 1)).to eq '<a class="usa-pagination__button" aria-label="Last page, page 5" href="/complaints?page=5">5</a>'
      end
    end
  end

  describe "#paginate" do
    context "with 1 page of results and no page selected" do
      it "returns empty set" do
        @page_total = 1
        expect(paginate).to eq []
      end
    end

    context "with 10 pages of results and 10th page selected" do
      it "returns 1st page, separator, then 8, 9, 10" do
        controller.params[:page] = 10
        @page_total = 10
        expect(paginate).to eq [1, "|", 8, 9, 10]
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
