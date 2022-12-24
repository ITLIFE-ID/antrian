# frozen_string_literal: true

# == Schema Information
#
# Table name: company_working_days
#
#  id           :bigint           not null, primary key
#  closing_time :datetime
#  day          :integer
#  deleted_at   :datetime
#  open_time    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :bigint
#
# Indexes
#
#  index_company_working_days_on_company_id  (company_id)
#  index_company_working_days_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :company_working_day do
    association :workable, factory: :company
    closing_time { DateTime.current.change({hour: 18, min: 0, sec: 0}) }
    day { rand(1..7) }
    open_time { DateTime.current.change({hour: 8, min: 0, sec: 0}) }
  end

  factory :service_working_day do
    association :workable, factory: :service
    closing_time { DateTime.current.change({hour: 18, min: 0, sec: 0}) }
    day { rand(1..7) }
    open_time { DateTime.current.change({hour: 8, min: 0, sec: 0}) }
  end
end
