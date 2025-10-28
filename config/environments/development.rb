Rails.application.configure do
  # Reload code mỗi request
  config.enable_reloading = true
  config.eager_load = false

  # Hiển thị lỗi đầy đủ
  config.consider_all_requests_local = true

  # Caching dev
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # ActiveStorage
  config.active_storage.service = :local

  # Mailer setup (gửi thật)
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com", # hoặc server bạn dùng
    port: 587,
    domain: "example.com",
    user_name: ENV["GMAIL_USERNAME"], # email gửi
    password: ENV["GMAIL_PASSWORD"],   # mật khẩu / app password
    authentication: "plain",
    enable_starttls_auto: true
  }

  # ActiveJob chạy ngay lập tức trong dev
  config.active_job.queue_adapter = :inline

  # Logs & database
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.assets.quiet = true
end



# Hướng dẫn chạy:
# 1️⃣ Chạy Sidekiq (nếu muốn test job bất đồng bộ): `bundle exec sidekiq`
# 2️⃣ Chạy Rails server: `rails s`
