Sentry.init do |config|
  config.dsn = "https://c6868950b0e042b5822cf7c1976f97a1@o1287201.ingest.sentry.io/6501890"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
