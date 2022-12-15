# frozen_string_literal: true

# == Schema Information
#
# Table name: user_counters
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  counter_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_counters_on_counter_id              (counter_id)
#  index_user_counters_on_deleted_at              (deleted_at)
#  index_user_counters_on_user_id                 (user_id)
#  index_user_counters_on_user_id_and_counter_id  (user_id,counter_id) UNIQUE
#
class UserCounter < ApplicationRecord
  belongs_to :counter
  belongs_to :user

  validates_uniqueness_of :counter_id, scope: :user_id
end
