# syntax=docker/dockerfile:1

# ----------------------------
# Base Ruby image
# ----------------------------
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

# ----------------------------
# Build stage
# ----------------------------
FROM base AS build

# Cài dependencies cần thiết
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential git libpq-dev libvips pkg-config nodejs yarn && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Copy Gemfile trước để cache layer
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.23 && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle "${BUNDLE_PATH}"/ruby/*/cache

# Copy toàn bộ source
COPY . .

# Precompile bootsnap
RUN bundle exec bootsnap precompile app/ lib/

# ❌ Skip admin_test initializer khi precompile
ENV RUNNING_ASSET_PRECOMPILE=1
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
ENV RUNNING_ASSET_PRECOMPILE=

# ----------------------------
# Runtime stage
# ----------------------------
FROM base

# Cài runtime dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Copy bundle & source từ build
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Entrypoint để fix tmp/pids, sockets, db prepare
COPY --chown=root:root bin/docker-entrypoint /rails/bin/docker-entrypoint
RUN chmod +x /rails/bin/docker-entrypoint

# Tạo user không root
RUN useradd rails --create-home --shell /bin/bash && \
    mkdir -p tmp/pids tmp/sockets && \
    chown -R rails:rails db log storage tmp

USER rails
WORKDIR /rails

# ⚙️ Entrypoint
ENTRYPOINT ["./bin/docker-entrypoint"]

# ⚡ Puma port
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
