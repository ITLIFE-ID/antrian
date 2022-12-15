# frozen_string_literal: true

# == Schema Information
#
# Table name: client_displays
#
#  id                  :bigint           not null, primary key
#  client_display_type :string
#  deleted_at          :datetime
#  ip_address          :string
#  location            :string
#  name                :string
#  volume              :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  building_id         :bigint
#
# Indexes
#
#  index_client_displays_on_building_id  (building_id)
#  index_client_displays_on_deleted_at   (deleted_at)
#
FactoryBot.define do
  factory :client_display do
    association :building
    client_display_type { ClientDisplay.client_display_types.first.first }
    ip_address { Faker::Internet.unique.ip_v4_address }
    location { "DEPAN LOBI" }
  end
end
