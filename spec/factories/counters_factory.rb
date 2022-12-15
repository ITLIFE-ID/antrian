# frozen_string_literal: true

# == Schema Information
#
# Table name: counters
#
#  id         :bigint           not null, primary key
#  closed     :boolean          default(FALSE)
#  deleted_at :datetime
#  number     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  service_id :bigint
#
# Indexes
#
#  index_counters_on_deleted_at  (deleted_at)
#  index_counters_on_service_id  (service_id)
#
FactoryBot.define do
  factory :counter do
    association :service
    closed { [true, false].sample }
    number { rand(1..999) }
  end
end
