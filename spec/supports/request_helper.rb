# frozen_string_literal: true

module RequestHelper
  def response_body
    JSON.parse(response.body)
  end

  def response_data
    response_body["data"]
  end

  def response_body_attributes
    response_data["attributes"]
  end

  def response_body_error_code(index)
    response_body["errors"][index]["code"]
  end

  def response_relationship_include(key)
    response_body["included"].count { |relation| relation["type"] == key } >= 1
  end

  def headers_auth
    headers["Authorization"]
  end
end
