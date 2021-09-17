class Api
  def self.request(system, endpoint, args = {})
    Api
      .namespaced_class(system.camelize, endpoint.camelize)
      .new(**args)
      .request
  end

  def self.namespaced_class(system, endpoint)
    # this method will return the full namespaced Api  wrapper class.
    # this will look like Api::FakeData::Hses::Issues or Api::Hses::Issues
    Api
      .namespace
      .const_get(system)
      .const_get(endpoint)
  end

  def self.namespace
    Api.needs_fake_data? ? Api::FakeData : Api
  end

  def self.needs_fake_data?
    Rails.env.development? || Rails.env.test? || Rails.env.ci?
  end
end
