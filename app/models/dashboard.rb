# == Schema Information
#
# Table name: dashboards
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  total      :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint
#
# Indexes
#
#  index_dashboards_on_company_id  (company_id)
#  index_dashboards_on_deleted_at  (deleted_at)
#
class Dashboard < ApplicationRecord
  belongs_to :company
  validates :name, presence: true, uniqueness: {scope: :company_id}
  validates :total, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
