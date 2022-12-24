# frozen_string_literal: true

# == Schema Information
#
# Table name: services
#
#  id               :bigint           not null, primary key
#  active           :boolean          default(TRUE)
#  closed           :boolean          default(FALSE)
#  deleted_at       :datetime
#  letter           :string
#  max_quota        :integer
#  max_service_time :integer
#  name             :string
#  priority         :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :bigint
#  parent_id        :bigint           default(0)
#  service_type_id  :bigint
#
# Indexes
#
#  index_services_on_company_id             (company_id)
#  index_services_on_deleted_at             (deleted_at)
#  index_services_on_letter_and_company_id  (letter,company_id) UNIQUE
#  index_services_on_parent_id              (parent_id)
#  index_services_on_service_type_id        (service_type_id)
#
class Service < ApplicationRecord
  has_many :working_days, as: :workable
  has_many :closing_days, as: :closeable
  has_many :service_clientdisplays, as: :clientdisplay_able  
  has_many :client_displays, through: :service_clientdisplays
  
  has_many :service_buildings
  has_many :counters
  has_many :children, class_name: "Service", foreign_key: "parent_id", inverse_of: :parent
  belongs_to :parent, class_name: "Service", foreign_key: "parent_id", optional: true,
    inverse_of: :children

  belongs_to :service_type
  belongs_to :company

  validates_presence_of :name, :letter
  validates_inclusion_of %i[active priority], in: [false, true]

  validates_uniqueness_of :letter, scope: :company_id

  validates_numericality_of :max_quota, only_integer: true, greater_than_or_equal_to: 1,
    less_than_or_equal_to: 999

  validates_numericality_of :max_service_time, only_integer: true, greater_than_or_equal_to: 1
end
