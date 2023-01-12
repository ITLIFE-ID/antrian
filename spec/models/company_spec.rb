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
require "rails_helper"

RSpec.describe Company, type: :model do
  it { should have_many :satisfaction_indices }

  it { should have_many :services }
  it { should have_many :satisfaction_indices }
  it { should have_many :buildings }
  it { should have_many :users }
  it { should have_many :administrators }
  it { should have_many(:client_displays).through(:buildings) }
  it { should have_many(:counters).through(:services) }
  it { should have_many :service_types }
  it { should have_many :file_storages }

  it { should validate_presence_of :name }
  it { should validate_presence_of :address }
  it { should validate_presence_of :phone_number }
  it { should validate_uniqueness_of :name }

  it { should validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90) }
  it { should validate_numericality_of(:latitude).is_less_than_or_equal_to(90) }

  it { should validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180) }
  it { should validate_numericality_of(:longitude).is_less_than_or_equal_to(180) }

  describe "#parent & #children" do
    context "given a child has a parent" do
      it "should be able to do parent tree" do
        c1 = create(:company)
        c2 = create(:company, parent: c1)

        expect(c1.children).to include(c2)
        expect(c2.parent).to eq c1
      end
    end
  end

  describe "api_key validation" do
    context "given no initial data when create" do
      it "should auto filled" do
        obj = build_stubbed(:company)
        expect(obj.valid?).to be true
        expect(obj.api_key.present?).to be true
      end
    end
  end

  describe "Phone number validation" do
    context "given string for phone number" do
      it "should invalid" do
        obj = build_stubbed(:company, phone_number: "aaa")
        expect(obj.valid?).to be false
      end
    end

    context "given invalid area code" do
      it "should invalid" do
        obj = build_stubbed(:company, phone_number: "+182121217937")
        expect(obj.valid?).to be false
      end
    end

    context "given valid" do
      it "should valid" do
        obj = build_stubbed(:company, phone_number: "+6282121217937")
        expect(obj.valid?).to be true
      end
    end
  end
end
