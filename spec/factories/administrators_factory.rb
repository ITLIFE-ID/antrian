# frozen_string_literal: true

# == Schema Information
#
# Table name: administrators
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  name                   :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  company_id             :bigint
#
# Indexes
#
#  index_administrators_on_company_id            (company_id)
#  index_administrators_on_confirmation_token    (confirmation_token) UNIQUE
#  index_administrators_on_deleted_at            (deleted_at)
#  index_administrators_on_email                 (email) UNIQUE
#  index_administrators_on_reset_password_token  (reset_password_token) UNIQUE
#  index_administrators_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :administrator do
    association :company

    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.phone_number_with_country_code }
    password { "Password000" }
  end
end
