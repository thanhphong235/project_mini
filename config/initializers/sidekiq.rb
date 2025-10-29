# frozen_string_literal: true

require "sidekiq"

# Nếu có REDIS_URL, dùng Sidekiq bình thường
if ENV["REDIS_URL"].present?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV.fetch("REDIS_URL") }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV.fetch("REDIS_URL") }
  end

  # Thiết lập queue mặc định
  Sidekiq.default_job_options = { "queue" => "default" }

  Rails.logger.info "✅ Sidekiq configured with Redis at #{ENV['REDIS_URL']}"
else
  # Nếu không có Redis (Render Free), dùng inline
  Rails.application.config.active_job.queue_adapter = :inline
  Rails.logger.warn "⚠️ REDIS_URL not set. Sidekiq jobs will run inline."
end
