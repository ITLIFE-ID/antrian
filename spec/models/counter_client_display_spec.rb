# == Schema Information
#
# Table name: counter_client_displays
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_display_id :bigint
#  counter_id        :bigint
#
# Indexes
#
#  index_counter_client_displays_on_client_display_id           (client_display_id)
#  index_counter_client_displays_on_counter_and_client_display  (counter_id,client_display_id) UNIQUE
#  index_counter_client_displays_on_counter_id                  (counter_id)
#  index_counter_client_displays_on_deleted_at                  (deleted_at)
#
require "rails_helper"

RSpec.describe CounterClientDisplay, type: :model do
  it { should belong_to :counter }
  it { should belong_to :client_display }
  it { should validate_uniqueness_of(:counter_id).scoped_to(:client_display_id).ignoring_case_sensitivity }
end
