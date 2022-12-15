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
require "rails_helper"

RSpec.describe Building, type: :model do
  it { should have_many :service_buildings }
  it { should have_many :client_displays }
  it { should belong_to :company }
  it { should validate_uniqueness_of(:name).scoped_to(:company_id).ignoring_case_sensitivity }
end
