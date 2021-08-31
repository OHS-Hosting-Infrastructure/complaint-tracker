SecureHeaders::Configuration.default do |config|
  config.csp = config.csp.merge({
    default_src: %w['self'],
    font_src: %w['self'],
    form_action: %W['self' #{Rails.configuration.x.hses.auth_base}],
    frame_ancestors: %w['none'],
    img_src: %w['self' data:],
    script_src: %w['self'],
    style_src: %w['self'].tap { |style_src_values|
      if Rails.env.development?
        # webpack injects styles inline in development mode
        style_src_values << "'unsafe-inline'"
      end
    }
  })
end
