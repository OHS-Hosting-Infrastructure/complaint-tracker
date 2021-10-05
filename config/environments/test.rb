require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false
  config.action_view.cache_template_loading = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # HSES authentication
  config.x.hses.auth_base = ENV.fetch("HSES_AUTH_BASE", "https://staging.hses.ohs.acf.hhs.gov")
  config.x.hses.client_id = ENV.fetch("HSES_AUTH_CLIENT_ID", Rails.application.credentials.hses_client_id)
  config.x.hses.client_secret = ENV.fetch("HSES_AUTH_CLIENT_SECRET", Rails.application.credentials.hses_client_secret)
  config.x.bypass_auth = ENV["CT_BYPASS_AUTH"] == "true"

  # API configuration
  config.x.use_real_api_data = ENV["CT_USE_REAL_API_DATA"] == "true"

  # HSES API
  config.x.hses.api_hostname = ENV.fetch("HSES_API_HOSTNAME", "staging.hses.ohs.acf.hhs.gov")
  config.x.hses.api_username = ENV.fetch("HSES_API_USERNAME", "test.user")
  config.x.hses.api_password = ENV.fetch("HSES_API_PASSWORD", "test.password")

  # TTA Hub API
  config.x.tta.api_hostname = ENV.fetch("TTA_HUB_API_HOSTNAME", "tta-smarthub-staging.app.cloud.gov")
  config.x.tta.api_port = Integer(ENV.fetch("TTA_HUB_API_PORT", "443"))
  config.x.tta.use_ssl = ENV.fetch("TTA_HUB_API_SCHEME", "https") == "https"
end
