# frozen_string_literal: true

# == Schema Information
#
# Table name: company_closing_days
#
#  id          :bigint           not null, primary key
#  date        :date
#  deleted_at  :datetime
#  finish_time :datetime
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
# Indexes
#
#  index_company_closing_days_on_company_id  (company_id)
#  index_company_closing_days_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :company_closing_day do
    association :closeable, factory: :company
    date { Time.current }
    finish_time { Time.current.change({hour: 18, min: 0, sec: 0}) }
    start_time { Time.current.change({hour: 8, min: 0, sec: 0}) }
  end

  factory :service_closing_day do
    association :closeable, factory: :service
    date { Time.current }
    finish_time { Time.current.change({hour: 18, min: 0, sec: 0}) }
    start_time { Time.current.change({hour: 8, min: 0, sec: 0}) }
  end
end
