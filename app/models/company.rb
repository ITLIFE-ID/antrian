# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id           :bigint           not null, primary key
#  address      :string
#  api_key      :string
#  deleted_at   :datetime
#  latitude     :string
#  longitude    :string
#  name         :string
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  parent_id    :bigint
#
# Indexes
#
#  index_companies_on_deleted_at  (deleted_at)
#  index_companies_on_name        (name) UNIQUE
#  index_companies_on_parent_id   (parent_id)
#
class Company < ApplicationRecord
  has_many :working_days, as: :workable
  has_many :closing_days, as: :closeable
  has_many :services
  has_many :satisfaction_indices
  has_many :buildings
  has_many :users
  has_many :administrators
  has_many :client_displays, through: :buildings
  has_many :counters, through: :services
  has_many :service_types
  has_many :file_storages, as: :file_able
  has_many :children, class_name: "Company", foreign_key: "parent_id", inverse_of: :parent
  belongs_to :parent, class_name: "Company", foreign_key: "parent_id", optional: true,
    inverse_of: :children

  has_one_attached :logo

  validates_presence_of :name, :address, :api_key, :phone_number
  validates_uniqueness_of :name
  validates :phone_number, phone: {possible: true, types: [:mobile]}
  validates :latitude, numericality: {greater_than_or_equal_to: -90, less_than_or_equal_to: 90}
  validates :longitude, numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}

  before_validation { self.api_key = SecureRandom.uuid if api_key.blank? }
end
