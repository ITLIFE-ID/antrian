# frozen_string_literal: true

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
#
FactoryBot.define do
  factory :voice_over do
    name { Faker::Name.name }
    slug {}
  end
end
