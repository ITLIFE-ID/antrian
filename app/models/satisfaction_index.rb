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
#  index_satisfaction_indices_on_company_id                   (company_id)
#  index_satisfaction_indices_on_deleted_at                   (deleted_at)
#  index_satisfaction_indices_on_name_and_company_id          (name,company_id) UNIQUE
#  index_satisfaction_indices_on_order_number_and_company_id  (order_number,company_id) UNIQUE
#
class SatisfactionIndex < ApplicationRecord
  belongs_to :company
  validates :name, presence: true,
    uniqueness: {scope: :company_id, case_sensitive: false, message: "Tidak boleh sama"}

  validates :order_number, presence: true,
    uniqueness: {scope: :company_id, message: "Tidak boleh sama"},
    numericality: {only_integer: true, greater_than: 0}

  def name=(value)
    super(value&.downcase)
  end
end
