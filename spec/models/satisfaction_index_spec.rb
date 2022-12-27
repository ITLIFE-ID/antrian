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
#  index_satisfaction_indices_on_company_id                   (company_id)
#  index_satisfaction_indices_on_deleted_at                   (deleted_at)
#  index_satisfaction_indices_on_name_and_company_id          (name,company_id) UNIQUE
#  index_satisfaction_indices_on_order_number_and_company_id  (order_number,company_id) UNIQUE
#
require "rails_helper"

RSpec.describe SatisfactionIndex, type: :model do
  it { should belong_to :company }
  it { should validate_presence_of :name }
  it { should validate_presence_of :order_number }  
  it { should validate_uniqueness_of(:name).scoped_to(:company_id).case_insensitive.with_message("Tidak boleh sama") }
  it { should validate_uniqueness_of(:order_number).scoped_to(:company_id).ignoring_case_sensitivity.with_message("Tidak boleh sama") }
end
