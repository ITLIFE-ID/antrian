# == Schema Information
#
# Table name: user_satisfaction_indices
#
#  id                     :bigint           not null, primary key
#  deleted_at             :datetime
#  officer_name           :string
#  rating                 :integer
#  review                 :string
#  satifcation_index_name :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  satisfaction_index_id  :bigint
#  today_queue_id         :bigint
#
# Indexes
#
#  index_user_satisfaction_indices_on_deleted_at              (deleted_at)
#  index_user_satisfaction_indices_on_satisfaction_and_queue  (satisfaction_index_id,today_queue_id) UNIQUE
#  index_user_satisfaction_indices_on_satisfaction_index_id   (satisfaction_index_id)
#  index_user_satisfaction_indices_on_today_queue_id          (today_queue_id)
#
require "rails_helper"

RSpec.describe UserSatisfactionIndex, type: :model do
  it { should belong_to :satisfaction_index }
  it { should belong_to :today_queue }
  it { should validate_presence_of :officer_name }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :review }
  it { should validate_presence_of :satifcation_index_name }
  it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(1) }
  it { should validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
  it { should validate_numericality_of(:rating).only_integer }
end
