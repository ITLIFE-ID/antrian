# == Schema Information
#
# Table name: dashboard_details
#
#  id           :bigint           not null, primary key
#  date         :date
#  deleted_at   :datetime
#  total        :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :bigint
#  dashboard_id :bigint
#
# Indexes
#
#  index_dashboard_details_on_company_id    (company_id)
#  index_dashboard_details_on_dashboard_id  (dashboard_id)
#  index_dashboard_details_on_deleted_at    (deleted_at)
#
class DashboardDetail < ApplicationRecord
  belongs_to :company
  belongs_to :dashboard
  validates :total, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  has_many :today_queues
  has_many :backup_queues

  validates_date :date
end
