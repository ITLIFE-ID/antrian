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
require "rails_helper"

RSpec.describe Service, type: :model do
  it { should have_many :working_days }
  it { should have_many :closing_days }
  it { should have_many :service_clientdisplays }
  it { should have_many :counters }

  it { should belong_to :service_type }
  it { should belong_to :company }

  it { should validate_presence_of :name }
  it { should validate_presence_of :letter }
  it { should validate_numericality_of(:max_quota).is_greater_than_or_equal_to(1) }
  it { should validate_numericality_of(:max_service_time).is_greater_than_or_equal_to(1) }
  it { should validate_numericality_of(:max_quota).is_less_than_or_equal_to(999) }
  it { should validate_numericality_of(:max_quota).only_integer }
  it { should validate_presence_of(:letter) }
  it { should have_many(:client_displays).through(:service_clientdisplays) }

  describe "#parent & #children" do
    context "given a child has a parent" do
      it "should be able to do parent tree" do
        c1 = FactoryBot.create(:service)
        c2 = FactoryBot.create(:service, parent: c1)

        expect(c1.children).to include(c2)
        expect(c2.parent).to eq c1
      end
    end
  end
end
