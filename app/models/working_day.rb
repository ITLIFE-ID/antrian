# frozen_string_literal: true

# == Schema Information
#
# Table name: working_days
#
#  id            :bigint           not null, primary key
#  closing_time  :time
#  day           :integer
#  deleted_at    :datetime
#  open_time     :time
#  workable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  workable_id   :bigint
#
# Indexes
#
#  index_working_days_on_day_and_workable_id_and_workable_type  (day,workable_id,workable_type) UNIQUE
#  index_working_days_on_deleted_at                             (deleted_at)
#  index_working_days_on_workable                               (workable_type,workable_id)
#
class WorkingDay < ApplicationRecord
  belongs_to :workable, polymorphic: true

  validates_datetime :open_time, before: :closing_time
  validates_datetime :closing_time, after: :open_time

  validates_uniqueness_of :day, scope: [:workable_id, :workable_type]

  validates_numericality_of :day, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 7
end
