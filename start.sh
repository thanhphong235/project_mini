#!/bin/bash

echo "Running migrations..."
bundle exec rails db:migrate RAILS_ENV=production

echo "Precompiling assets..."
bundle exec rails assets:precompile RAILS_ENV=production

echo "Starting Puma server..."
bundle exec puma -C config/puma.rb
