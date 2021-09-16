require_relative "./production"

Rails.application.configure do
  config.assets.compile = true
  config.public_file_server.enabled = true

  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  config.x.bypass_auth = true

  # override settings for production which are not used for ci
  config.x.hses.auth_base = nil
  config.x.hses.client_id = nil
  config.x.hses.client_secret = nil
end
