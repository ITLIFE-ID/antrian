# frozen_string_literal: true

# == Schema Information
#
# Table name: service_buildings
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  building_id :bigint
#  service_id  :bigint
#
# Indexes
#
#  index_service_buildings_on_building_id                 (building_id)
#  index_service_buildings_on_deleted_at                  (deleted_at)
#  index_service_buildings_on_service_id                  (service_id)
#  index_service_buildings_on_service_id_and_building_id  (service_id,building_id) UNIQUE
#
class ServiceBuilding < ApplicationRecord
  belongs_to :service
  belongs_to :building

  validates_uniqueness_of :service_id, scope: :building_id
end
