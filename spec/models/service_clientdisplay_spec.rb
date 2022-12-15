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
require "rails_helper"

RSpec.describe ServiceClientdisplay, type: :model do
  it { should belong_to :service }
  it { should belong_to :client_display }
  it { should validate_uniqueness_of(:service_id).scoped_to(:client_display_id) }
end
