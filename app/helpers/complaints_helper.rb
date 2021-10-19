module ComplaintsHelper
  include Pagy::Frontend

  FORMATTED_STATUS = {
    0 => "In Progress",
    1 => "Closed",
    2 => "Rec. Closure",
    3 => "Rec. Reopening",
    4 => "Reopened"
  }

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

  def status(complaint_attributes)
    formatted_status = FORMATTED_STATUS[complaint_attributes[:status][:id]]
    if complaint_attributes[:creationDate] > 1.week.ago && formatted_status == "In Progress"
      "New"
    else
      formatted_status
    end
  end
end
