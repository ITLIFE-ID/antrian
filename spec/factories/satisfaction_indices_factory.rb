# frozen_string_literal: true

# == Schema Information
#
# Table name: satisfaction_indices
#
#  id           :bigint           not null, primary key
#  deleted_at   :datetime
#  name         :string
#  order_number :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :bigint
#
# Indexes
#
#  index_satisfaction_indices_on_company_id  (company_id)
#  index_satisfaction_indices_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :satisfaction_index do
    association :company
    name { "Puas" }
    order_number { 1 }
  end
end
