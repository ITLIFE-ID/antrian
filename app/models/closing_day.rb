# frozen_string_literal: true

# == Schema Information
#
# Table name: closing_days
#
#  id             :bigint           not null, primary key
#  closeable_type :string
#  date           :date
#  deleted_at     :datetime
#  finish_time    :datetime
#  start_time     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  closeable_id   :bigint
#
# Indexes
#
#  index_closing_days_on_closeable                                 (closeable_type,closeable_id)
#  index_closing_days_on_date_and_closeable_id_and_closeable_type  (date,closeable_id,closeable_type) UNIQUE
#  index_closing_days_on_deleted_at                                (deleted_at)
#
class ClosingDay < ApplicationRecord
  belongs_to :closeable, polymorphic: true

  validates_date :date, on_or_after: :today
  validates_datetime :start_time, before: :finish_time
  validates_datetime :finish_time, after: :start_time

  validates_uniqueness_of :date, scope: [:closeable_id, :closeable_type]
  validates_presence_of :date, :finish_time, :start_time
end
