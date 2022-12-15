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
#  index_voice_overs_on_name        (name) UNIQUE
#
class VoiceOver < ApplicationRecord
  validates_presence_of :name
  validates :slug, presence: true, uniqueness: {case_insensitive: false}

  def slug=(value)
    super(name&.parameterize&.underscore&.upcase)
  end
end
