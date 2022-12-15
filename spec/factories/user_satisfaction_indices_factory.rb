# frozen_string_literal: true

# == Schema Information
#
# Table name: user_satisfaction_indices
#
#  id                     :bigint           not null, primary key
#  deleted_at             :datetime
#  officer_name           :string
#  rating                 :integer
#  review                 :string
#  satifcation_index_name :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  company_id             :bigint
#  satisfaction_index_id  :bigint
#  today_queue_id         :bigint
#
# Indexes
#
#  index_user_satisfaction_indices_on_company_id             (company_id)
#  index_user_satisfaction_indices_on_deleted_at             (deleted_at)
#  index_user_satisfaction_indices_on_satisfaction_index_id  (satisfaction_index_id)
#  index_user_satisfaction_indices_on_today_queue_id         (today_queue_id)
#
FactoryBot.define do
  factory :user_satisfaction_index do
    association :today_queue
    association :satisfaction_index

    officer_name { Faker::Name.name }
    rating { rand(1..5).sample }
    review { Faker::Quote.famous_last_words }
    satisfaction_index_name {}
  end
end
