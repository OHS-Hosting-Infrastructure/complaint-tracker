require "paginator"

module ComplaintsHelper
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

  def page_link(link_page, current_page)
    is_current = link_page == current_page

    options = {
      class: page_link_class(is_current),
      "aria-label": page_link_label(link_page)
    }
    options["aria-current"] = "page" if is_current

    link_to link_page, complaints_path(page: link_page), options
  end

  def page_link_class(is_current)
    is_current ? "usa-pagination__button usa-current" : "usa-pagination__button"
  end

  def page_link_label(page)
    page == @page_total ? "Last page, page #{page}" : "Page #{page}"
  end

  def paginate
    Paginator.new(params[:page], @page_total).pages
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
