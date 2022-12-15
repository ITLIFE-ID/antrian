# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  confirmation_sent_at     :datetime
#  confirmation_token       :string
#  confirmed_at             :datetime
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string
#  deleted_at               :datetime
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  failed_attempts          :integer          default(0), not null
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string
#  locked_at                :datetime
#  name                     :string
#  otp_auth_secret          :string
#  otp_challenge_expires    :datetime
#  otp_enabled              :boolean          default(FALSE), not null
#  otp_enabled_on           :datetime
#  otp_failed_attempts      :integer          default(0), not null
#  otp_mandatory            :boolean          default(FALSE), not null
#  otp_persistence_seed     :string
#  otp_recovery_counter     :integer          default(0), not null
#  otp_recovery_secret      :string
#  otp_session_challenge    :string
#  phone_number             :string
#  refresh_token            :string
#  refresh_token_created_at :datetime
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  sign_in_count            :integer          default(0), not null
#  unconfirmed_email        :string
#  unlock_token             :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  company_id               :bigint
#
# Indexes
#
#  index_users_on_company_id             (company_id)
#  index_users_on_confirmation_token     (confirmation_token) UNIQUE
#  index_users_on_email                  (email) UNIQUE
#  index_users_on_otp_challenge_expires  (otp_challenge_expires)
#  index_users_on_otp_session_challenge  (otp_session_challenge) UNIQUE
#  index_users_on_reset_password_token   (reset_password_token) UNIQUE
#  index_users_on_unlock_token           (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.phone_number_with_country_code }
    password { "Password000" }
    refresh_token { SecureRandom.uuid }
    refresh_token_created_at { Time.current }
  end
end
