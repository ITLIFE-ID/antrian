# frozen_string_literal: true

# == Schema Information
#
# Table name: play_lists
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  file_type         :string
#  playing           :boolean          default(FALSE)
#  title             :string
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
  belongs_to :client_display

  enum file_type: {music: "MUSIC", video: "VIDEO"}
  validates_inclusion_of :playing, in: [false, true]
  validates_presence_of :title, :file_type
end
