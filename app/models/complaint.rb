class Complaint
  attr_reader :id, :attributes

  EVENT_FIELDS = %i[
    issueLastUpdated
    creationDate
    closedDate
    reopenedDate
    initialContactDate
  ].freeze
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
    @hses_complaint = hses_complaint
  end

  def events
    @events ||= attributes.select { |key, value|
      EVENT_FIELDS.include?(key.to_sym) && value.present?
    }.to_a.map { |field|
      [field.first, Time.parse(field.last)]
    }.sort_by(&:last).reverse
  end

  def event_label(attribute_name)
    EVENT_LABELS[attribute_name] || "Updated"
  end

  def method_missing(method_name, *arguments, &block)
    camelized_method = method_name.to_s.camelize(:lower)
    if attributes.has_key?(camelized_method)
      attributes[camelized_method]
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    attributes.has_key?(method_name.to_s.camelize(:lower)) || super
  end
end
