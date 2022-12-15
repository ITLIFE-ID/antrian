# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Sidekiq.default_job_options["retry"] = 2

Sidekiq.configure_server do |config|
  config.redis = {url:      (ENV["REDIS_URL"] || "redis://localhost:6379/0"),
                   password: ENV.fetch("REDIS_PASSWORD", nil)}
end

Sidekiq.configure_client do |config|
  config.redis = {url:      (ENV["REDIS_URL"] || "redis://localhost:6379/0"),
                   password: ENV.fetch("REDIS_PASSWORD", nil)}
end

schedule_file = "config/schedule.yml"
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
