# frozen_string_literal: true

# == Schema Information
#
# Table name: service_clientdisplays
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_display_id :bigint
#  service_id        :bigint
#
# Indexes
#
#  index_service_clientdisplays_on_client_display_id  (client_display_id)
#  index_service_clientdisplays_on_service_id         (service_id)
#
FactoryBot.define do
  factory :service_clientdisplay do
    association :client_display
    association :service
  end
end
