# frozen_string_literal: true

# == Schema Information
#
# Table name: service_clientdisplays
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_display_id :bigint
#  service_id        :bigint
#
# Indexes
#
#  index_service_clientdisplays_on_client_display_id           (client_display_id)
#  index_service_clientdisplays_on_deleted_at                  (deleted_at)
#  index_service_clientdisplays_on_service_and_client_display  (service_id,client_display_id) UNIQUE
#  index_service_clientdisplays_on_service_id                  (service_id)
#
class ServiceClientdisplay < ApplicationRecord
  belongs_to :service
  belongs_to :client_display

  validates_uniqueness_of :service_id, scope: :client_display_id
end
