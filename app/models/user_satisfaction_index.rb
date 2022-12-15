# frozen_string_literal: true

# == Schema Information
#
# Table name: user_satisfaction_indices
#
#  id                     :bigint           not null, primary key
#  deleted_at             :datetime
#  officer_name           :string
#  rating                 :integer
#  review                 :string
#  satifcation_index_name :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  satisfaction_index_id  :bigint
#  today_queue_id         :bigint
#
# Indexes
#
#  index_user_satisfaction_indices_on_deleted_at              (deleted_at)
#  index_user_satisfaction_indices_on_satisfaction_and_queue  (satisfaction_index_id,today_queue_id) UNIQUE
#  index_user_satisfaction_indices_on_satisfaction_index_id   (satisfaction_index_id)
#  index_user_satisfaction_indices_on_today_queue_id          (today_queue_id)
#
class UserSatisfactionIndex < ApplicationRecord
  belongs_to :today_queue
  belongs_to :satisfaction_index
  validates_presence_of :officer_name, :rating, :review, :satifcation_index_name

  validates_uniqueness_of :satisfaction_index_id, scope: :today_queue_id
  validates_numericality_of :rating, only_integer: true, greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
end
