class Timeline::Event
  attr_reader :date, :name

  def formatted_date
    date.strftime("%m/%d/%Y")
  end

  def timeline_partial
    "generic_timeline_event"
  end
end
