# == Schema Information
#
# Table name: service_closing_days
#
#  id          :bigint           not null, primary key
#  date        :date
#  deleted_at  :datetime
#  finish_time :datetime
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  service_id  :bigint
#
# Indexes
#
#  index_service_closing_days_on_date_and_service_id  (date,service_id) UNIQUE
#  index_service_closing_days_on_deleted_at           (deleted_at)
#  index_service_closing_days_on_service_id           (service_id)
#
require "rails_helper"

RSpec.describe ServiceClosingDay, type: :model do
  it { should belong_to :service }
  it { should validate_presence_of :date }
  it { should validate_presence_of :finish_time }
  it { should validate_presence_of :start_time }
  it { should_not allow_value("Date").for(:date) }
  it { should allow_value(Time.current).for(:date) }

  describe "Start time and Finish time validation" do
    context "given start time is over than finish time and finish time is early than start time" do
      it "should invalid" do
        obj = FactoryBot.build_stubbed(:service_closing_day,
          finish_time: Time.current.change({hour: 8, min: 0, sec: 0}),
          start_time: Time.current.change({hour: 18, min: 0, sec: 0}))
        expect(obj.valid?).to be false
      end
    end
  end
end
