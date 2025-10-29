# frozen_string_literal: true

Rails.application.configure do
  # ----------------------------
  # 🔧 Code loading
  # ----------------------------
  config.cache_classes = true
  config.eager_load = true
  config.enable_reloading = false
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # ----------------------------
  # 🖼️ Assets (JS, CSS, images)
  # ----------------------------
  config.assets.compile = true
  config.assets.digest = true

  # ----------------------------
  # 🌐 Hosts / SSL
  # ----------------------------
  config.force_ssl = true
  config.hosts.clear
  config.hosts << "project-mini-igbt.onrender.com"
  config.hosts << ".onrender.com"
  config.hosts << /.*\.onrender\.com/

  # ----------------------------
  # 🗃️ Database / ActiveRecord
  # ----------------------------
  config.active_record.dump_schema_after_migration = false

  # ----------------------------
  # 🧵 Active Job
  # ----------------------------
  # mặc định chạy inline để không cần Redis trên Render Free
  config.active_job.queue_adapter = :inline
  config.active_job.queue_name_prefix = "foods_drinks_app_production"

  # ----------------------------
  # 📦 Active Storage
  # ----------------------------
  config.active_storage.service = :local
  Rails.application.config.active_storage.queues.analysis = :inline
  Rails.application.config.active_storage.queues.purge    = :inline
  Rails.application.config.active_storage.queues.mirror   = :inline

  # ----------------------------
  # 📧 Action Mailer (Gmail)
  # ----------------------------
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.default_url_options = {
    host: ENV["HOST"] || "project-mini-igbt.onrender.com",
    protocol: "https"
  }

  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: ENV["MAIL_DOMAIN"] || "gmail.com",
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
  }

  # ----------------------------
  # ⚙️ Logging
  # ----------------------------
  config.logger = ActiveSupport::Logger.new(STDOUT)
                        .tap { |logger| logger.formatter = ::Logger::Formatter.new }
                        .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [:request_id]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym

  # ----------------------------
  # 🌍 I18n fallback
  # ----------------------------
  config.i18n.fallbacks = true

  # ----------------------------
  # ⚠️ Deprecations
  # ----------------------------
  config.active_support.report_deprecations = false
end
