module ComplaintsHelper
  include Pagy::Frontend

  STATUS_SORT_ORDER = {
    "New" => 0,
    "Rec. Reopening" => 1,
    "Reopened" => 2,
    "In Progress" => 3,
    "Rec. Closure" => 4,
    "Closed" => 5
  }

  def page_link(page, current: false)
    options = {
      class: page_link_class(current),
      "aria-label": page_link_label(page)
    }
    options["aria-current"] = "page" if current

    link_to page, complaints_path(page: page), options
  end

  def page_link_class(current)
    current ? "usa-pagination__button usa-current" : "usa-pagination__button"
  end

  def page_link_label(page)
    page == @pagy.series.last ? "Last page, page #{page}" : "Page #{page}"
  end

  def sort_date(date)
    date.to_datetime.to_i
  end

  def sort_status(status_label)
    STATUS_SORT_ORDER[status_label]
  end
end
