# frozen_string_literal: true

class BlockedJwt < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
end
