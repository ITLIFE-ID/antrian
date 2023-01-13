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
require "rails_helper"

RSpec.describe Dashboard, type: :model do
  it { should belong_to :company }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to([:company_id]).ignoring_case_sensitivity }
end
