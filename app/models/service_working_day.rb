# frozen_string_literal: true

# == Schema Information
#
# Table name: service_working_days
#
#  id           :bigint           not null, primary key
#  closing_time :time
#  day          :integer
#  deleted_at   :datetime
#  open_time    :time
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  service_id   :bigint
#
# Indexes
#
#  index_service_working_days_on_day_and_service_id  (day,service_id) UNIQUE
#  index_service_working_days_on_deleted_at          (deleted_at)
#  index_service_working_days_on_service_id          (service_id)
#
class ServiceWorkingDay < ApplicationRecord
  belongs_to :service

  validates_time :open_time, before: :closing_time
  validates_time :closing_time, after: :open_time

  validates :day,
    uniqueness: {scope: :service_id},
    numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 7, only_integer: true}
end
