source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "listen"
  gem "rack-mini-profiler"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "annotate", github: "ctran/annotate_models"
  gem "better_errors"
  gem "binding_of_caller"
  gem "bullet"
  gem "spring"
  gem "standard"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "database_cleaner-active_record"
  gem "rspec-rails"
  gem "rswag-specs"
  gem "shoulda-matchers"
  gem "timecop"
  gem "vcr"
  gem "webdrivers"
  gem "webmock"
end

# security
gem "action_policy"
gem "administrate", github: "thoughtbot/administrate"
gem "devise"
gem "devise-jwt"
gem "permisi"
gem "rack-attack"
gem "rack-cors"
gem "rotp"

# background job
gem "sidekiq"
gem "sidekiq-cron"

gem "ransack"

# API
gem "jsonapi.rb"
gem "rswag-api"
gem "rswag-ui"

# notification
gem "fcm"
gem "mqtt", github: "njh/ruby-mqtt"
gem "noticed"

gem "aasm"
gem "acts_as_paranoid"
gem "aws-sdk-s3"
gem "devise-otp"
gem "devise_token_auth"
gem "dotenv-rails"
gem "language_filter"
gem "mixpanel-ruby"
gem "paper_trail"
gem "phonelib"
gem "prawn"
gem "resolv"
gem "rqrcode"
gem "sentry-rails"
gem "terbilang"
gem "to_bool"
gem "validates_timeliness", github: "adzap/validates_timeliness"
gem "email_validator", "~> 2.2"
gem "fasterer", "~> 0.10.0"
