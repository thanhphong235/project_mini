# frozen_string_literal: true
Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false
  config.eager_load = true

  # Full error reports are disabled
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # ActiveStorage
  config.active_storage.service = :local

  # Force all access over SSL
  config.force_ssl = true

  # Logging to STDOUT
  config.logger = ActiveSupport::Logger.new(STDOUT)
                        .tap { |logger| logger.formatter = ::Logger::Formatter.new }
                        .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [:request_id]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym

  # Assets
  config.assets.compile = true

  # I18n fallback
  config.i18n.fallbacks = true

  # Deprecation
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations
  config.active_record.dump_schema_after_migration = false

  # Action Mailer
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: ENV["HOST"], protocol: "https" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: ENV["MAIL_DOMAIN"] || "gmail.com",
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
  }

  # Active Job
  config.active_job.queue_adapter = :sidekiq
  config.active_job.queue_name_prefix = "foods_drinks_app_production"

  # Host authorization (optional, configure your domain)
  # config.hosts << "example.com"
end
