source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "~> 8.0.2"
gem "pg"
gem "puma"

# JavaScript/CSS bundling
gem "jsbundling-rails"
gem "cssbundling-rails"

# Hotwire
gem "turbo-rails"
gem "stimulus-rails"

# Asset pipeline
gem "sprockets-rails"

# JSON APIs
gem "jsonapi.rb"

# Active Storage
gem "image_processing"

# Redis & background jobs
gem 'redis', '~> 5.4'
gem "sidekiq"
gem "sidekiq-cron"

# Authentication & Authorization
gem "devise"
gem "devise-jwt"
gem "devise-otp"
gem "devise_token_auth"
gem "action_policy"
gem "rack-attack"
gem "rack-cors"
gem "permisi"

# Admin dashboard
gem 'administrate', '1.0.0.beta3'

# Search/filtering
gem "ransack"

# Notifications
gem "fcm"
gem "mqtt", github: "njh/ruby-mqtt"
gem "noticed"

# Misc features
gem "aasm"
gem "paranoia"
gem "aws-sdk-s3"
gem "dotenv-rails"
gem "language_filter"
gem "mixpanel-ruby"
gem "paper_trail"
gem "phonelib"
gem "prawn"
gem "rqrcode"
gem "sentry-ruby"
gem "sentry-rails"
gem "terbilang"
gem "email_validator", "~> 2.2"
gem "breadcrumbs_on_rails", "~> 4.1"
gem "marcel", "~> 1.0"
gem "wicked_pdf", "~> 2.6"
gem "wkhtmltopdf-binary", "~> 0.12.6"
gem "ipaddress", "~> 0.8.3"
gem 'validates_timeliness', '~> 8.0'
gem "rswag-specs"
gem "rswag-api"
gem "rswag-ui"

# Performance & lint
gem "bootsnap", require: false
gem "fasterer", "~> 0.10.0"
gem "htmlbeautifier", "~> 1.4"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
  gem "listen"
  # gem "annotate", github: "ctran/annotate_models"
  gem "better_errors"
  gem "binding_of_caller"
  gem "bullet"
  gem "spring"
  gem "standard"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "database_cleaner-active_record"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "timecop"
  gem "vcr"
  gem "webdrivers"
  gem "webmock"
  gem "cucumber", "~> 8.0"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
