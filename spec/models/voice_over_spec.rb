# == Schema Information
#
# Table name: voice_overs
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_voice_overs_on_deleted_at  (deleted_at)
#  index_voice_overs_on_name        (name) UNIQUE
#
require "rails_helper"

RSpec.describe VoiceOver, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :slug }
  it { should validate_uniqueness_of(:slug).case_insensitive }
end
