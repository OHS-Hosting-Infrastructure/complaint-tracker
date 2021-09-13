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

  def status(complaint_attributes)
    formatted_status = FORMATTED_STATUS[complaint_attributes[:status][:id]]
    if complaint_attributes[:creationDate] > 1.week.ago && formatted_status == "In Progress"
      "New"
    else
      formatted_status
    end
  end
end
