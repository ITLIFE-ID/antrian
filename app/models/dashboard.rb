# == Schema Information
#
# Table name: dashboards
#
#  id         :bigint           not null, primary key
#  name       :string
#  total      :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Dashboard < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :total, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
