class Timeline
  attr_reader :complaint_events

  EVENT_LABELS = {
    issueLastUpdated: "Updated",
    creationDate: "Created in HSES",
    closedDate: "Closed",
    reopenedDate: "Reopened",
    initialContactDate: "Initial contact from complaint"
  }.with_indifferent_access.freeze

  def initialize(complaint_attributes, tta_reports)
    @complaint_events = needed_attributes(complaint_attributes)
      .map { |event| ComplaintEvent.new(event) }

    @tta_events = tta_reports.map { |report| TtaEvent.new(report) }
  end

  def events
    @events ||= all_events
      .sort_by(&:date)
      .reverse
  end

  private

  def all_events
    @complaint_events + @tta_events
  end

  def needed_attributes(attributes)
    attributes.select do |key, value|
      EVENT_LABELS.key?(key) && value.present?
    end
  end
end

class Event
  attr_reader :date, :name

  def formatted_date
    date.strftime("%m/%d/%Y")
  end
end

class Timeline::ComplaintEvent < Event
  def initialize(event)
    @name = event[0]
    @date = Date.parse(event[1])
  end

  def label
    Timeline::EVENT_LABELS[name] || "Updated"
  end
end

class Timeline::TtaEvent < Event
  def initialize(issue_tta_report)
    @name = issue_tta_report.tta_report_display_id
    @date = issue_tta_report.start_date
  end

  def label
    "TTA Activity: #{name}"
  end
end
