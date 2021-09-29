module ApiDelegator
  def self.use(system, endpoint, args = {})
    ApiDelegator
      .namespaced_class(system.camelize, endpoint.camelize)
      .new(**args)
  end

  def self.namespaced_class(system, endpoint)
    # this method will return the full namespaced Api  wrapper class.
    # this will look like Api::FakeData::Hses::Issues or Api::Hses::Issues
    ApiDelegator
      .namespace
      .const_get(system)
      .const_get(endpoint)
  end

  def self.namespace
    Rails.configuration.x.use_real_api_data ? Api : Api::FakeData
  end
end
