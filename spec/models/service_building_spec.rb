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
require "rails_helper"

RSpec.describe ServiceBuilding, type: :model do
  it { should belong_to :service }
  it { should belong_to :building }
  it { should validate_uniqueness_of(:service_id).scoped_to(:building_id).ignoring_case_sensitivity }
end
