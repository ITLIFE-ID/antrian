# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Antrian
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "UTC"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_controller.include_all_helpers = false
    Rails.application.routes.default_url_options[:host] = ENV.fetch("HOST", nil)
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**/*.{rb,yml}").to_s]
    config.i18n.fallbacks = [:en]
    config.assets.debug = true
    config.active_record.cache_versioning = false

    config.active_record.default_timezone = :utc
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += %W[#{config.root}/lib]    

    config.generators do |gen|
      gen.orm :active_record
      gen.test_framework :rspec
      gen.fixture_replacement :factory_bot, dir: "spec/factories"
      gen.factory_bot suffix: "factory"
      gen.view_specs = false
      gen.controller_specs = false
      gen.routing_specs = false
      gen.helper = false
      gen.stylesheets = false
      gen.javascripts = false
    end

    config.to_prepare do
      Devise::Mailer.layout "devise_mailer"
      Devise::SessionsController.layout "home"
      # Devise::Mailer.helper :email
    end

    config.after_initialize do  
      begin    
        Rails.application.config.mqtt_connect = MQTT::Client.connect(host: ENV.fetch("MQTT_HOST"), port: ENV.fetch("MQTT_PORT"))
        MQTTSubscriber.new.run
      rescue => e        
        ApplicationService.new.return_errors(e)
      end
    end
  end
end
