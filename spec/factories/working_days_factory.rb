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
FactoryBot.define do
  factory :working_day do
    trait :default do
      closing_time { DateTime.current.change({hour: 18, min: 0, sec: 0}) }
      day { rand(1..7) }
      open_time { DateTime.current.change({hour: 8, min: 0, sec: 0}) }
    end

    trait :for_company do
      association :workable, factory: :company
    end

    trait :for_service do
      association :workable, factory: :service
    end

    factory :working_day_for_company, traits: %i[default for_company]
    factory :working_day_for_service, traits: %i[default for_service]
  end  
end
