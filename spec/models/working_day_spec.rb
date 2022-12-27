# == Schema Information
#
# Table name: working_days
#
#  id            :bigint           not null, primary key
#  closing_time  :time
#  day           :integer
#  deleted_at    :datetime
#  open_time     :time
#  workable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  workable_id   :bigint
#
# Indexes
#
#  index_working_days_on_day_and_workable_id_and_workable_type  (day,workable_id,workable_type) UNIQUE
#  index_working_days_on_deleted_at                             (deleted_at)
#  index_working_days_on_workable                               (workable_type,workable_id)
#
require "rails_helper"

RSpec.describe WorkingDay, type: :model do
  it { should belong_to :workable }
  it { should have_db_column(:workable_id).of_type(:integer) }
  it { should have_db_column(:workable_type).of_type(:string) }
  it { should validate_numericality_of(:day).is_greater_than_or_equal_to(1) }
  it { should validate_numericality_of(:day).is_less_than_or_equal_to(7) }
  it { should validate_numericality_of(:day).only_integer }
  subject { described_class.new(workable_id: 1, workable_type: Counter) }
  it { should validate_uniqueness_of(:day).scoped_to(:workable_id, :workable_type).ignoring_case_sensitivity }

  describe "Open time and Closing time validation" do
    context "given Open time is over than Closing time and Closing time is early than Open time" do
      it "should invalid" do
        obj = build_stubbed(:working_day_for_company,
          closing_time: Time.current.change({hour: 8, min: 0, sec: 0}),
          open_time: Time.current.change({hour: 18, min: 0, sec: 0}))
        expect(obj.valid?).to be false
      end
    end
  end
end
