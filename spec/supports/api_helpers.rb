# frozen_string_literal: true

def auth_header(user)
  Devise::JWT::TestHelpers.auth_headers({}, user,
    scope: :"#{user.class.to_s.downcase}")["Authorization"]
end

def json
  JSON.parse(response.body)
end

def login_with_api(user)
  post "/api/auth/login", params: {
    user: {
      phone_number: user.phone_number,
      password: user.password
    }
  }
end
