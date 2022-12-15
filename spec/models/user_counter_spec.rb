# == Schema Information
#
# Table name: user_counters
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  counter_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_counters_on_counter_id              (counter_id)
#  index_user_counters_on_deleted_at              (deleted_at)
#  index_user_counters_on_user_id                 (user_id)
#  index_user_counters_on_user_id_and_counter_id  (user_id,counter_id) UNIQUE
#
require "rails_helper"

RSpec.describe UserCounter, type: :model do
  it { should belong_to :counter }
  it { should belong_to :user }
end
