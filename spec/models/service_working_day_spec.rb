# == Schema Information
#
# Table name: service_working_days
#
#  id           :bigint           not null, primary key
#  closing_time :time
#  day          :integer
#  deleted_at   :datetime
#  open_time    :time
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  service_id   :bigint
#
# Indexes
#
#  index_service_working_days_on_day_and_service_id  (day,service_id) UNIQUE
#  index_service_working_days_on_deleted_at          (deleted_at)
#  index_service_working_days_on_service_id          (service_id)
#
require "rails_helper"

RSpec.describe ServiceWorkingDay, type: :model do
  it { should belong_to :service }
  it { should validate_numericality_of(:day).is_greater_than_or_equal_to(1) }
  it { should validate_numericality_of(:day).is_less_than_or_equal_to(7) }
  it { should validate_numericality_of(:day).only_integer }
  it { should validate_uniqueness_of(:day).scoped_to(:service_id).ignoring_case_sensitivity }

  describe "Open time and Closing time validation" do
    context "given Open time is over than Closing time and Closing time is early than Open time" do
      it "should invalid" do
        obj = FactoryBot.build_stubbed(:company_working_day,
          closing_time: Time.current.change({hour: 8, min: 0, sec: 0}),
          open_time: Time.current.change({hour: 18, min: 0, sec: 0}))
        expect(obj.valid?).to be false
      end
    end
  end
end
