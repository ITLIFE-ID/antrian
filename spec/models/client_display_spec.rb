# == Schema Information
#
# Table name: client_displays
#
#  id                  :bigint           not null, primary key
#  client_display_type :string
#  deleted_at          :datetime
#  ip_address          :string
#  location            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  building_id         :bigint
#
# Indexes
#
#  index_client_displays_on_building_id                 (building_id)
#  index_client_displays_on_deleted_at                  (deleted_at)
#  index_client_displays_on_ip_address_and_building_id  (ip_address,building_id) UNIQUE
#
require "rails_helper"

RSpec.describe ClientDisplay, type: :model do
  it { should have_many :shared_clientdisplays }
  it { should have_many(:services) }
  it { should have_many(:counters) }
  it { should belong_to :building }
  it { should validate_presence_of :client_display_type }
  it { should validate_presence_of :ip_address }
  it { should allow_value("192.168.0.1").for(:ip_address) }
  it { should_not allow_value("aaaa").for(:ip_address) }
  it { should validate_uniqueness_of(:ip_address).scoped_to(:building_id).ignoring_case_sensitivity }
end
