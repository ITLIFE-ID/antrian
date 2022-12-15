# == Schema Information
#
# Table name: play_lists
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  file_type         :string
#  playing           :boolean          default(FALSE)
#  title             :string
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
  it { should validate_presence_of :title }
  it { should validate_presence_of :file_type }
end
