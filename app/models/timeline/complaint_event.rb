class Timeline::ComplaintEvent < Timeline::Event
  def initialize(event)
    @name = event[0]
    @date = Date.parse(event[1])
  end

  def label
    Timeline::EVENT_LABELS[name] || "Updated"
  end
end
