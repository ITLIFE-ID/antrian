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
FactoryBot.define do
  factory :play_list do
    association :client_display
    file_type { %i[music video].sample }
    playing { [true, false].sample }
    title { Faker::Artist.name }
  end
end
