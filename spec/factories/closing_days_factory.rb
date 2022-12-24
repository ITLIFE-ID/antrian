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
FactoryBot.define do
  factory :closing_day do
    trait :default do
      date { Time.current }
      finish_time { Time.current.change({hour: 18, min: 0, sec: 0}) }
      start_time { Time.current.change({hour: 8, min: 0, sec: 0}) }
    end

    trait :for_company do
      association :closeable, factory: :company
    end

    trait :for_service do
      association :closeable, factory: :service
    end

    factory :closing_day_for_company, traits: %i[default for_company]
    factory :closing_day_for_service, traits: %i[default for_service]
  end
end
