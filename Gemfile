# frozen_string_literal: true
source "https://rubygems.org"

ruby "3.0.2"

# --- Rails core ---
gem "rails", "~> 7.1.5", ">= 7.1.5.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "sprockets-rails"
gem "sassc-rails"

# --- Authentication ---
gem "devise"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "omniauth-twitter"

# --- UI / Frontend ---
gem "bootstrap", "~> 5.3"
gem "jquery-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# --- Utilities ---
gem "jbuilder"
gem "ransack" # Tìm kiếm / Lọc sản phẩm
gem "dotenv-rails", groups: [:development, :test] # Load biến môi trường từ .env

# --- Windows timezone fix (chỉ áp dụng khi cần) ---
gem "tzinfo-data", platforms: %i[mswin mswin64 mingw x64_mingw jruby]

# --- Development & Debugging ---
group :development, :test do
  gem "debug", platforms: %i[mri mswin mswin64 mingw x64_mingw]
end

group :development do
  gem "web-console"
end

# --- Testing ---
group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
