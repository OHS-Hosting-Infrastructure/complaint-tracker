class Api
  def self.request(system, endpoint, args = nil)
    "Api::#{Api.env}#{system.capitalize}::#{endpoint.capitalize}".constantize.new(*args).request
  end

  def self.env
    if Rails.env == "development" || Rails.env == "test"
      "FakeData::"
    end
  end
end
