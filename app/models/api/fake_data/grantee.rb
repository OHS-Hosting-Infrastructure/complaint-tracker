require "ffaker_wrapper"

class Api::FakeData::Grantee
  include FfakerWrapper

  def initialize(id:)
    @id = id
  end

  def data
    @data ||= {
      id: @id,
      type: "grantees",
      attributes: {
        name: grantee_name,
        region: identifier
      },
      links: {
        self: "https://example.com/self/TODO",
        html: "https://example.com/html/TODO"
      }
    }
  end
end
