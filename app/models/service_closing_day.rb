# frozen_string_literal: true

# == Schema Information
#
# Table name: service_closing_days
#
#  id          :bigint           not null, primary key
#  date        :date
#  deleted_at  :datetime
#  finish_time :datetime
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  service_id  :bigint
#
# Indexes
#
#  index_service_closing_days_on_date_and_service_id  (date,service_id) UNIQUE
#  index_service_closing_days_on_deleted_at           (deleted_at)
#  index_service_closing_days_on_service_id           (service_id)
#
class ServiceClosingDay < ApplicationRecord
  belongs_to :service

  validates_date :date, on_or_after: :today
  validates_datetime :start_time, before: :finish_time
  validates_datetime :finish_time, after: :start_time

  validates :date, presence: true, uniqueness: {scope: :service_id}

  validates_presence_of :finish_time, :start_time
end
