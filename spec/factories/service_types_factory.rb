# frozen_string_literal: true

# == Schema Information
#
# Table name: service_types
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint
#
# Indexes
#
#  index_service_types_on_company_id  (company_id)
#  index_service_types_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :service_type do
    association :company
    name { Faker::Name.unique.name }
    slug { Faker::Name.unique.name.upcase }
  end
end
