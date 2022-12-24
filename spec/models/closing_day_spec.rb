# == Schema Information
#
# Table name: closing_days
#
#  id             :bigint           not null, primary key
#  closeable_type :string
#  date           :date
#  deleted_at     :datetime
#  finish_time    :datetime
#  start_time     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  closeable_id   :bigint
#
# Indexes
#
#  index_closing_days_on_closeable                                 (closeable_type,closeable_id)
#  index_closing_days_on_date_and_closeable_id_and_closeable_type  (date,closeable_id,closeable_type) UNIQUE
#  index_closing_days_on_deleted_at                                (deleted_at)
#
require "rails_helper"

RSpec.describe ClosingDay, type: :model do
  it { should belong_to :closeable }
  it { should validate_presence_of :date }
  it { should validate_presence_of :finish_time }
  it { should validate_presence_of :start_time }
  it { should_not allow_value("Date").for(:date) }
  it { should allow_value(Time.current).for(:date) }

  describe "Start time and Finish time validation" do
    context "given start time is over than finish time and finish time is early than start time" do
      it "should invalid" do
        obj = FactoryBot.create(:closing_day_for_company,
          finish_time: Time.current.change({hour: 8, min: 0, sec: 0}),
          start_time: Time.current.change({hour: 18, min: 0, sec: 0}))
        expect(obj.valid?).to be false
      end
    end
  end
end
