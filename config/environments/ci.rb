require_relative "./production"

Rails.application.configure do
  config.assets.compile = true
  config.public_file_server.enabled = true

  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  config.x.bypass_auth = true
  config.x.use_real_api_data = false

  # override settings for production which are not used for ci
  config.x.hses.auth_base = ENV.fetch("HSES_AUTH_BASE", "https://staging.hses.ohs.acf.hhs.gov")
  config.x.hses.client_id = nil
  config.x.hses.client_secret = nil
end
