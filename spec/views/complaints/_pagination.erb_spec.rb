require "rails_helper"

RSpec.describe "rendering pagination" do
  context "when multiple pages" do
    it "returns pagination and selects first page if none set" do
      @page_total = 10

      render partial: "complaints/pagination"
      expect(rendered).to include '<nav aria-label="Pagination" class="usa-pagination">'
      expect(rendered).to include '<a class="usa-pagination__button usa-current" aria-label="Page 1" aria-current="page" href="/complaints?page=1">1</a>'
    end

    it "selects appropriate page" do
      @page_total = 10
      params[:page] = 5

      render partial: "complaints/pagination"
      expect(rendered).to include '<a class="usa-pagination__button usa-current" aria-label="Page 5" aria-current="page" href="/complaints?page=5">5</a>'
    end
  end

  context "when one page" do
    it "has no pagination when only one page" do
      @page_total = 1

      render partial: "complaints/pagination"
      expect(rendered).not_to include '<nav aria-label="Pagination" class="usa-pagination">'
    end
  end
end
