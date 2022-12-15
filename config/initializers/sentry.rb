# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV.fetch("DSN_SENTRY", nil)
  config.breadcrumbs_logger = [:active_support_logger]
  config.traces_sample_rate = 1.0
end
