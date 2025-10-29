# frozen_string_literal: true

Rails.application.configure do
  # Không reload code giữa các request
  config.enable_reloading = false
  config.cache_classes = true
  config.eager_load = true

  # Tắt hiển thị lỗi chi tiết trên môi trường production
  config.consider_all_requests_local = false

  # Bật cache để tối ưu hiệu suất
  config.action_controller.perform_caching = true

  # Cấu hình Active Storage (Render chưa hỗ trợ S3 => dùng local)
  config.active_storage.service = :local

  # Bắt buộc truy cập qua HTTPS
  config.force_ssl = true

  # ----------------------------
  # ⚙️ Logging
  # ----------------------------
  config.logger = ActiveSupport::Logger.new(STDOUT)
                        .tap { |logger| logger.formatter = ::Logger::Formatter.new }
                        .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [:request_id]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym

  # ----------------------------
  # 🎨 Assets (JS, CSS, images)
  # ----------------------------
  config.assets.compile = true
  config.assets.digest = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # ----------------------------
  # 🌍 I18n fallback
  # ----------------------------
  config.i18n.fallbacks = true

  # ----------------------------
  # ⚠️ Deprecation
  # ----------------------------
  config.active_support.report_deprecations = false

  # ----------------------------
  # 🗃️ Database schema
  # ----------------------------
  config.active_record.dump_schema_after_migration = false

  # ----------------------------
  # 📧 Action Mailer
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
  # 🧵 Active Job (Sidekiq)
  # ----------------------------
  config.active_job.queue_adapter = :sidekiq
  config.active_job.queue_name_prefix = "foods_drinks_app_production"

  # ----------------------------
  # 🌐 Host authorization
  # ----------------------------
  config.hosts.clear
  config.hosts << "project-mini-igbt.onrender.com"
  config.hosts << ".onrender.com" # Cho phép tất cả subdomain của Render
  config.hosts << /.*\.onrender\.com/
end
