# frozen_string_literal: true

# == Schema Information
#
# Table name: buildings
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint
#
# Indexes
#
#  index_buildings_on_company_id  (company_id)
#  index_buildings_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :building do
    association :company
    name { Faker::Company.unique.name }
  end
end
