# frozen_string_literal: true

# == Schema Information
#
# Table name: service_types
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint
#
# Indexes
#
#  index_service_types_on_company_id           (company_id)
#  index_service_types_on_company_id_and_name  (company_id,name) UNIQUE
#  index_service_types_on_deleted_at           (deleted_at)
#
class ServiceType < ApplicationRecord
  belongs_to :company
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  def name=(value)
    super(value&.capitalize)
  end

  def slug=(value)
    super(name&.parameterize&.underscore&.upcase)
  end
end
