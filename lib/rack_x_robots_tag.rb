# frozen_string_literal: true

module Rack
  class XRobotsTag
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      headers["X-Robots-Tag"] = "none" if ENV["DISALLOW_ALL_WEB_CRAWLERS"].present?

      [status, headers, response]
    end
  end
end
