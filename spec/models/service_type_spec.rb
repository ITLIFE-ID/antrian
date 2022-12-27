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
require "rails_helper"

RSpec.describe ServiceType, type: :model do
  it { should belong_to :company }
  it { should validate_presence_of :name }
  it { should validate_presence_of :slug }
  it { should validate_uniqueness_of(:slug).ignoring_case_sensitivity }
  it { should validate_uniqueness_of(:name).ignoring_case_sensitivity }

  describe "Slug auto fill" do
    context "given slug is blank" do
      it "should fill from name and upcase" do
        obj = build_stubbed(:service_type, name: "pendaftaran", slug: "")
        expect(obj.slug).to eq "PENDAFTARAN"
      end
    end
  end
end
