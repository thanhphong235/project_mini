require_relative "boot"

require "rails/all"

# ✅ Chỉ load .env trong môi trường development hoặc test
if %w[development test].include?(ENV["RAILS_ENV"])
  require "dotenv"
  Dotenv.load(".env")
end

Bundler.require(*Rails.groups)

module FoodsDrinksApp
  class Application < Rails::Application
    config.load_defaults 7.1
    config.time_zone = "Hanoi"
    config.active_record.default_timezone = :local
    config.autoload_lib(ignore: %w(assets tasks))
  end
end
