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
#  index_counters_on_deleted_at             (deleted_at)
#  index_counters_on_number_and_service_id  (number,service_id) UNIQUE
#  index_counters_on_service_id             (service_id)
#
class Counter < ApplicationRecord
  has_many :shared_clientdisplays, as: :clientdisplay_able
  has_many :user_counters

  belongs_to :service

  validates_inclusion_of :closed, in: [false, true]
  validates_numericality_of :number, only_integer: true, greater_than_or_equal_to: 0,
    less_than_or_equal_to: 999

  validates_uniqueness_of :number, scope: :service_id
end
