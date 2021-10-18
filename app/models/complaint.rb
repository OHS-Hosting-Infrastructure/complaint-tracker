class Complaint
  attr_reader :id, :attributes

  EVENT_LABELS = {
    issueLastUpdated: "Updated",
    creationDate: "Created in HSES",
    closedDate: "Closed",
    reopenedDate: "Reopened",
    initialContactDate: "Initial contact from complaint"
  }.with_indifferent_access.freeze

  def initialize(hses_complaint)
    @id = hses_complaint[:id]
    @attributes = hses_complaint[:attributes].with_indifferent_access
  end

  def due_date?
    due_date.present?
  end

  def due_soon?
    due_date? && due_date < 1.week.from_now
  end

  def grantee
    attributes["grantee"]
  end

  def overdue?
    due_date? && due_date.before?(Date.current)
  end

  def relative_due_date_html
    if overdue?
      "<span class=\"ct-timeline__overdue\">Overdue (Due #{formatted_due_date})</span>"
    elsif due_date == Date.current
      "<span class=\"ct-timeline__due-soon\">Due today (#{formatted_due_date})</span>"
    elsif due_soon?
      "<span class=\"ct-timeline__due-soon\">Due in #{day_string} (#{formatted_due_date})</span>"
    else
      "<span>Due in #{day_string} (#{formatted_due_date})</span>"
    end
  end

  def summary
    attributes["summary"]
  end

  private

  def day_string
    ActionController::Base.helpers.pluralize(relative_time_til_due, "day")
  end

  def due_date
    Date.parse(attributes[:dueDate])
  rescue
    nil
  end

  def formatted_due_date
    due_date.strftime("%m/%d/%Y")
  end

  def relative_time_til_due
    (Date.current...due_date).count
  end
end
