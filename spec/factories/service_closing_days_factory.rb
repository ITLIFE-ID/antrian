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
#  index_service_closing_days_on_deleted_at  (deleted_at)
#  index_service_closing_days_on_service_id  (service_id)
#
FactoryBot.define do
  factory :service_closing_day do
    association :service
    date { Time.current }
    finish_time { Time.current.change({hour: 18, min: 0, sec: 0}) }
    start_time { Time.current.change({hour: 8, min: 0, sec: 0}) }
  end
end
