max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

rails_env = ENV.fetch("RAILS_ENV") { "production" }
environment rails_env

port ENV.fetch("PORT") { 3000 }
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Workers cho production
if rails_env == "production"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { 2 })
  workers worker_count if worker_count > 1
  preload_app! if worker_count > 1
end

plugin :tmp_restart
