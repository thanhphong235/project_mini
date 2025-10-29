# frozen_string_literal: true

# Sidekiq config cho cả Redis và Render Free (không Redis)
if ENV["REDIS_URL"].present?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDIS_URL"], size: 10, network_timeout: 5 }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDIS_URL"], size: 5, network_timeout: 5 }
  end
else
  # Không có Redis: chạy tất cả job inline
  require "active_job/queue_adapters/inline_adapter"
  Rails.application.config.active_job.queue_adapter = :inline
  puts "⚠️ REDIS_URL không được cấu hình. Sidekiq jobs sẽ chạy inline."
end

# Queue mặc định
Sidekiq.default_worker_options = { "queue" => "default" }
