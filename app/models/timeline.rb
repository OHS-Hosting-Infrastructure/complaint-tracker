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
