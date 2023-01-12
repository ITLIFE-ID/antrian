module SentryContext
  extend ActiveSupport::Concern

  included do
    before_action :set_sentry_context
  end

  def set_sentry_context
    Sentry.set_extras(params: params.to_unsafe_h, url: request.url)
    if defined? verify_authenticity_token
      if verify_authenticity_token && current_user.present?
        Sentry.set_user(id: current_user.id, name: current_user.name, email: current_user.email, user_id: current_user.user_id, role: current_user.role)
      end
    end  
  end
end
