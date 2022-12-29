# == Schema Information
#
# Table name: play_lists
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  playing           :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_display_id :bigint
#
# Indexes
#
#  index_play_lists_on_client_display_id  (client_display_id)
#  index_play_lists_on_deleted_at         (deleted_at)
#
require "rails_helper"

RSpec.describe PlayList, type: :model do
  it { should belong_to :client_display }
  it { should have_many :file_storages }
end
