# frozen_string_literal: true

# == Schema Information
#
# Table name: service_buildings
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  building_id :bigint
#  service_id  :bigint
#
# Indexes
#
#  index_service_buildings_on_building_id  (building_id)
#  index_service_buildings_on_service_id   (service_id)
#
FactoryBot.define do
  factory :service_building do
    association :service
    association :building
  end
end
