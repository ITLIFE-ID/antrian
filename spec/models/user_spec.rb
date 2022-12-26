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
#  index_users_on_deleted_at             (deleted_at)
#  index_users_on_email                  (email) UNIQUE
#  index_users_on_otp_challenge_expires  (otp_challenge_expires)
#  index_users_on_otp_session_challenge  (otp_session_challenge) UNIQUE
#  index_users_on_reset_password_token   (reset_password_token) UNIQUE
#  index_users_on_unlock_token           (unlock_token) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :phone_number }
  it { should allow_value("082121217937").for(:phone_number) }
  it { should_not allow_value("aaaa").for(:phone_number) }
  it { should allow_value("Password000").for(:password) }
  it { should allow_value("password").for(:password) }
  it { should_not allow_value("password@12").for(:password) }
end
