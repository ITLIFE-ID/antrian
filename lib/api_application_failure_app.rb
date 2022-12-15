# frozen_string_literal: true

require "json"

class ApiApplicationFailureApp < Devise::FailureApp
  def http_auth_body
    return super unless request_format == :json

    {errors: custom_errors}.to_json
  end

  private

  # Use custom errors for the API endpoints
  def custom_errors
    default = {status: "401", title: "Unauthorized", code: :unauthorized}
    case i18n_message
    when I18n.t("devise.failure.unauthenticated")
      [{
        **status_title,
        detail: I18n.t("devise.failure.unauthenticated_api")
      }]
    when "revoked token"
      [{**default, detail: I18n.t("devise.failure.revoked_token")}]
    when "Not enough or too many segments"
      [{**default, detail: I18n.t("devise.failure.not_enough_or_too_many_segments_token")}]
    when "Signature verification raised"
      [{**default, detail: I18n.t("devise.failure.invalid_token")}]
    when "nil user"
      [{**default, detail: I18n.t("devise.failure.user_not_found")}]
    else
      i18n_message
    end
  end
end
