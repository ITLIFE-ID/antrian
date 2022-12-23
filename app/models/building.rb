# frozen_string_literal: true

# == Schema Information
#
# Table name: buildings
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint
#
# Indexes
#
#  index_buildings_on_company_id           (company_id)
#  index_buildings_on_company_id_and_name  (company_id,name) UNIQUE
#  index_buildings_on_deleted_at           (deleted_at)
#
class Building < ApplicationRecord
  has_many :client_displays
  belongs_to :company

  validates :name, presence: true, uniqueness: {scope: :company_id}
end
