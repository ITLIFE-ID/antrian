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
#  index_voiceover_buildings_on_building_id                      (building_id)
#  index_voiceover_buildings_on_deleted_at                       (deleted_at)
#  index_voiceover_buildings_on_voice_over_and_building_and_day  (voice_over_id,building_id,day) UNIQUE
#  index_voiceover_buildings_on_voice_over_id                    (voice_over_id)
#
class VoiceoverBuilding < ApplicationRecord
  belongs_to :building
  belongs_to :voice_over

  validates_numericality_of :day, only_integer: true, greater_than_or_equal_to: 1,
    less_than_or_equal_to: 7

  validates_uniqueness_of :voice_over_id, scope: [:building_id, :day]
end
