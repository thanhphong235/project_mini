# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.enable_reloading = false
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Serve static files if variable is set
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Assets
  config.assets.compile = true
  config.assets.digest = true

  # Allow all hosts (simplify)
  config.hosts.clear
  config.hosts << "projectmini-production.up.railway.app"
  config.hosts << "localhost"
  config.hosts << "127.0.0.1"


  # Database
  config.active_record.dump_schema_after_migration = false

  # Active Job
  config.active_job.queue_adapter = :inline
  config.active_job.queue_name_prefix = "foods_drinks_app_production"

  # Active Storage
  config.active_storage.service = :local
  Rails.application.config.active_storage.queues.analysis = :inline
  Rails.application.config.active_storage.queues.purge    = :inline
  Rails.application.config.active_storage.queues.mirror   = :inline

  # ✅ Mailer (chuẩn cho Gmail)
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    host: ENV['HOST'] || 'https://projectmini-production.up.railway.app',
    protocol: 'https'
  }
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               ENV["MAIL_DOMAIN"] || "gmail.com",
    user_name:            ENV["ADMIN_EMAIL"],             # 👈 tài khoản Gmail gửi mail
    password:             ENV["ADMIN_EMAIL_PASSWORD"],    # 👈 mật khẩu ứng dụng Gmail
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # Secret key
  config.secret_key_base = ENV['SECRET_KEY_BASE']

  # Logging
  config.logger = ActiveSupport::Logger.new(STDOUT)
                          .tap { |logger| logger.formatter = ::Logger::Formatter.new }
                          .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [:request_id]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym

  # I18n
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
end
