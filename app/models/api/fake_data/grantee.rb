require "ffaker_wrapper"

class Api::FakeData::Grantee
  include FfakerWrapper

  def data
    @data ||= {
      id: identifier,
      type: 'grantees',
      attributes: {
        name: name
      },
      links: {
        self: "https://example.com/TODO",
        html: "https://example.com/TODO"
      }
    }
  end
end
