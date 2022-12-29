# frozen_string_literal: true

# == Schema Information
#
# Table name: play_lists
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  playing           :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_display_id :bigint
#
# Indexes
#
#  index_play_lists_on_client_display_id  (client_display_id)
#  index_play_lists_on_deleted_at         (deleted_at)
#
class PlayList < ApplicationRecord
  has_many :file_storages, as: :file_able
  belongs_to :client_display

  validates_inclusion_of :playing, in: [false, true]
end
