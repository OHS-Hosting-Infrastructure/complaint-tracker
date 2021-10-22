class Grantee
  attr_reader :id, :attributes, :links

  EVENT_LABELS = {
    name: "Name",
    summary: "Summary"
  }.with_indifferent_access.freeze

  def initialize(hses_grantee:)
    @id = hses_grantee[:id]
    @attributes = hses_grantee[:attributes].with_indifferent_access
    @links = hses_grantee[:links].with_indifferent_access
  end

  def hses_link
    links["html"]
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
