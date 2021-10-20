class Grantee
  attr_reader :id, :attributes

  EVENT_LABELS = {
    name: "Name",
    summary: "Summary"
  }.with_indifferent_access.freeze

  def initialize(hses_grantee:)
    @id = hses_grantee[:id]
    @attributes = hses_grantee[:attributes].with_indifferent_access
  end

  def name
    attributes["name"]
  end

  def region
    attributes["region"]
  end

  def summary
    attributes["summary"]
  end
end
