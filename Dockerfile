# syntax = docker/dockerfile:1

# ----------------------------
# Base Ruby image
# ----------------------------
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

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

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential git libpq-dev libvips pkg-config nodejs yarn

# Copy Gemfile trước để cache bundle layer
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.23 && \
    bundle install --jobs 4 && \
    rm -rf ~/.bundle "${BUNDLE_PATH}"/ruby/*/cache

# Copy toàn bộ source
COPY . .

# Precompile bootsnap & assets
RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# ----------------------------
# Runtime stage
# ----------------------------
FROM base

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# 👤 Non-root user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails

# 🛠️ Entrypoint riêng (chạy db:prepare trước khi start)
COPY bin/docker-entrypoint /rails/bin/docker-entrypoint
RUN chmod +x /rails/bin/docker-entrypoint

ENTRYPOINT ["./bin/docker-entrypoint"]

EXPOSE 3000

# 🌐 Run Puma server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
