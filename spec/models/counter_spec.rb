# == Schema Information
#
# Table name: counters
#
#  id         :bigint           not null, primary key
#  closed     :boolean          default(FALSE)
#  deleted_at :datetime
#  number     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  service_id :bigint
#
# Indexes
#
#  index_counters_on_deleted_at             (deleted_at)
#  index_counters_on_number_and_service_id  (number,service_id) UNIQUE
#  index_counters_on_service_id             (service_id)
#
require "rails_helper"

RSpec.describe Counter, type: :model do
  it { should have_many :shared_clientdisplays }
  it { should have_many :user_counters }
  it { should belong_to :service }
  it { should validate_numericality_of(:number).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:number).is_less_than_or_equal_to(999) }
  it { should validate_numericality_of(:number).only_integer }
  it { should validate_uniqueness_of(:number).scoped_to(:service_id) }
end
