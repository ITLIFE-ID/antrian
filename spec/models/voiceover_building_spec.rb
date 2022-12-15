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
require "rails_helper"

RSpec.describe VoiceoverBuilding, type: :model do
  it { should belong_to :building }
  it { should belong_to :voice_over }
  it { should validate_numericality_of(:day).is_greater_than_or_equal_to(1) }
  it { should validate_numericality_of(:day).is_less_than_or_equal_to(7) }
  it { should validate_uniqueness_of(:voice_over_id).scoped_to([:building_id, :day]).ignoring_case_sensitivity }
end
