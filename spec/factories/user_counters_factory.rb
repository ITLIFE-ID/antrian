# frozen_string_literal: true

# == Schema Information
#
# Table name: user_counters
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  counter_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_counters_on_counter_id  (counter_id)
#  index_user_counters_on_user_id     (user_id)
#
FactoryBot.define do
  factory :user_counter do
    association :counter
    association :user
  end
end
