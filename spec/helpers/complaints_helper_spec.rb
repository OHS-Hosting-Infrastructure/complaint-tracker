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

  describe "#sort_status" do
    it "sorts New complaints first" do
      expect(sort_status("New")).to eq 0
    end

    it "sorts In Progress complaints in the middle" do
      expect(sort_status("In Progress")).to eq 3
    end

    it "sorts Closed complaints last" do
      expect(sort_status("Closed")).to eq 5
    end
  end
end
