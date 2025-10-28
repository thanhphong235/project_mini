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

  # Mailer setup (default: user email)
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "gmail.com",
    user_name: ENV["USER_EMAIL"],    # mặc định gửi bằng email user
    password: ENV["USER_EMAIL_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true,
    open_timeout: 10,
    read_timeout: 10
  }

  # ActiveJob chạy ngay lập tức trong dev
  config.active_job.queue_adapter = :inline

  # Logs & database
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.assets.quiet = true
end
