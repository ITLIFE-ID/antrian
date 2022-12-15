# frozen_string_literal: true

# == Schema Information
#
# Table name: voiceover_buildings
#
#  id            :bigint           not null, primary key
#  day           :integer
#  deleted_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  building_id   :bigint
#  voice_over_id :bigint
#
# Indexes
#
#  index_voiceover_buildings_on_building_id    (building_id)
#  index_voiceover_buildings_on_deleted_at     (deleted_at)
#  index_voiceover_buildings_on_voice_over_id  (voice_over_id)
#
FactoryBot.define do
  factory :voiceover_building do
    association :building
    association :voice_over
    day { rand(1..7) }
  end
end
