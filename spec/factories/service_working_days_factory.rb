# frozen_string_literal: true

# == Schema Information
#
# Table name: service_working_days
#
#  id           :bigint           not null, primary key
#  closing_time :datetime
#  day          :integer
#  deleted_at   :datetime
#  open_time    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  service_id   :bigint
#
# Indexes
#
#  index_service_working_days_on_service_id  (service_id)
#
FactoryBot.define do
  factory :service_working_day do
    association :service
    closing_time { DateTime.current.change({hour: 18, min: 0, sec: 0}) }
    day { rand(1..7) }
    open_time { DateTime.current.change({hour: 8, min: 0, sec: 0}) }
  end
end
