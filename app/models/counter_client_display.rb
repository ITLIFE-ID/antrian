# frozen_string_literal: true

# == Schema Information
#
# Table name: counter_client_displays
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_display_id :bigint
#  counter_id        :bigint
#
# Indexes
#
#  index_counter_client_displays_on_client_display_id           (client_display_id)
#  index_counter_client_displays_on_counter_and_client_display  (counter_id,client_display_id) UNIQUE
#  index_counter_client_displays_on_counter_id                  (counter_id)
#  index_counter_client_displays_on_deleted_at                  (deleted_at)
#
class CounterClientDisplay < ApplicationRecord
  belongs_to :counter
  belongs_to :client_display

  validates_uniqueness_of :counter_id, scope: :client_display_id
end
