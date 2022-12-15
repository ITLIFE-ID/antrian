# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id           :bigint           not null, primary key
#  address      :string
#  api_key      :string
#  deleted_at   :datetime
#  latitude     :string
#  longitude    :string
#  name         :string
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_companies_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :company do
    address { Faker::Address.full_address }
    api_key { SecureRandom.uuid }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    name { Faker::Company.unique.name }
    phone_number { Faker::PhoneNumber.phone_number_with_country_code }
  end
end
