# frozen_string_literal: true

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
class ClientDisplay < ApplicationRecord
  enum client_display_type: {tv: "TV", tab: "TAB", kiosk: "KIOSK", p10: "P10"}

  has_many :shared_clientdisplays
  has_many :services, through: :shared_clientdisplays, source: :shared_clientdisplays, source_type: 'Service'
  has_many :counters, through: :shared_clientdisplays, source: :shared_clientdisplays, source_type: 'Counter'  
  has_many :play_lists  

  belongs_to :building

  validates :client_display_type, presence: true
  validates :ip_address, presence: true, uniqueness: {scope: :building_id}, format: {with: Resolv::IPv4::Regex}
end
