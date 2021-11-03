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

  describe "#aria_sort" do
    it "returns the current sort direction if set" do
      @sort = "creationDate"
      expect(aria_sort("creationDate")).to eq "aria-sort=\"ascending\""
      @sort = "-creationDate"
      expect(aria_sort("creationDate")).to eq "aria-sort=\"descending\""
    end

    it "returns descending for creationDate when @sort is nil" do
      @sort = nil
      expect(aria_sort("creationDate")).to eq "aria-sort=\"descending\""
      expect(aria_sort("other")).to be_nil
    end
  end

  describe "#current_sort_direction" do
    context "@sort is nil" do
      it "returns descending for creationDate" do
        @sort = nil
        expect(current_sort_direction("creationDate")).to eq "descending"
      end

      it "returns nil for other columns" do
        @sort = nil
        expect(current_sort_direction("other")).to be_nil
      end
    end

    context "@sort is set without a -" do
      it "returns ascending when the column matches" do
        @sort = "creationDate"
        expect(current_sort_direction("creationDate")).to eq "ascending"
      end

      it "returns nil when the column does not match" do
        @sort = "creationDate"
        expect(current_sort_direction("other")).to be_nil
      end
    end

    context "@sort has a -" do
      it "returns descending when the column matches" do
        @sort = "-creationDate"
        expect(current_sort_direction("creationDate")).to eq "descending"
      end

      it "returns nil when the column does not match" do
        @sort = "-creationDate"
        expect(current_sort_direction("other")).to be_nil
      end
    end
  end
end
