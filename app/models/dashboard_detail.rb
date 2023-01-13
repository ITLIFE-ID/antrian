# == Schema Information
#
# Table name: dashboard_details
#
#  id           :bigint           not null, primary key
#  date         :date
#  total        :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  dashboard_id :bigint
#
# Indexes
#
#  index_dashboard_details_on_dashboard_id  (dashboard_id)
#
class DashboardDetail < ApplicationRecord
  belongs_to :dashboard
  validates :total, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  has_many :today_queues
  has_many :backup_queues

  validates_date :date
end
