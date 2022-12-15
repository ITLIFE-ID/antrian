# frozen_string_literal: true

# To be used in config/routes.rb

class ApiConstraints
  @@lowest_version = nil
  @@highest_version = 0

  def self.lowest_version
    @@lowest_version
  end

  def self.highest_version
    @@highest_version
  end

  def initialize(options)
    @version = options[:version]
    @default = options[:default]

    @@lowest_version = [@version].flatten.min if @default
    @@highest_version = [@@highest_version, @version].flatten.max
  end

  def matches?(req)
    @default || req.headers["Accept"] =~ regex
  end

  private

  def format_version
    if @version.instance_of?(Array)
      @version.join(",")
    else
      @version
    end
  end

  def regex
    %r{application/vnd.antrian.v[#{format_version}]\+json}
    # e.g. application/vnd.antrian.v1+json
    #      application/vnd.antrian.v2+json
    #      application/vnd.antrian.v3+json
  end
end
