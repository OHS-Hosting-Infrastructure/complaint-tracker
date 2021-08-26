SecureHeaders::Configuration.default do |config|
  config.csp = config.csp.merge({
    default_src: %w('self'),
    font_src: %w('self'),
    form_action: %w('self'),
    frame_ancestors: %w('none'),
    img_src: %w('self' data:),
    script_src: %w('self'),
    style_src: %w('self')
  })
end
