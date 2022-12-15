# frozen_string_literal: true

module CommonHelper
  def make_request(url, body = {})
    Faraday.post(url) do |req|
      req.headers["content-type"] = "application/json"
      req.body = body.to_json
    end
  end

  def make_form_request(url, body = {})
    Faraday.post(url) do |req|
      req.headers["content-type"] = "application/x-www-form-urlencoded"
      req.body = URI.encode_www_form(body)
    end
  end

  def valid_json?(string)
    !!JSON.parse(string)
  rescue JSON::ParserError
    false
  end
end
