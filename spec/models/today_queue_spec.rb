# == Schema Information
#
# Table name: today_queues
#
#  id                    :bigint           not null, primary key
#  attend                :boolean          default(FALSE)
#  date                  :date
#  deleted_at            :datetime
#  finish_time           :datetime
#  letter                :string
#  note                  :string
#  number                :integer
#  print_ticket_location :string
#  print_ticket_method   :string
#  print_ticket_time     :datetime
#  priority              :boolean          default(FALSE)
#  process_duration      :integer
#  service_type_slug     :string
#  start_time            :datetime
#  uniq_number           :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  counter_id            :bigint
#  parent_id             :bigint
#  service_id            :bigint
#
# Indexes
#
#  index_today_queues_on_counter_id                                 (counter_id)
#  index_today_queues_on_deleted_at                                 (deleted_at)
#  index_today_queues_on_number_and_date_and_service_id_and_letter  (number,date,service_id,letter) UNIQUE
#  index_today_queues_on_parent_id                                  (parent_id)
#  index_today_queues_on_service_id                                 (service_id)
#
require "rails_helper"

RSpec.describe TodayQueue, type: :model do
  it { should belong_to :service }
  it { should belong_to(:counter).optional }
  it { should validate_presence_of :letter }
  it { should validate_presence_of :uniq_number }
  it { should validate_presence_of :print_ticket_location }
  it { should validate_presence_of :print_ticket_time }
  it { should validate_presence_of :number }
  it { should validate_presence_of :service_type_slug }
  it { should validate_presence_of :date }
  it { should validate_numericality_of(:number).is_greater_than_or_equal_to(1) }
  it { should validate_numericality_of(:process_duration).is_greater_than_or_equal_to(1) }
  it { should validate_numericality_of(:number).is_less_than_or_equal_to(999) }
  it { should validate_numericality_of(:number).only_integer }
  it { should validate_uniqueness_of(:letter).scoped_to([:service_id, :number, :date]).ignoring_case_sensitivity }

  describe "Start time and finish time validation" do
    context "given Start time is over than finish time and finish time is early than Start time" do
      it "should invalid" do
        obj = build_stubbed(:today_queue,
          finish_time: Time.current.change({hour: 8, min: 0, sec: 0}),
          start_time: Time.current.change({hour: 18, min: 0, sec: 0}))

        expect(obj.valid?).to be false
      end
    end
  end

  describe "#parent & #children" do
    context "given a child has a parent" do
      it "should be able to do parent tree" do
        c1 = create(:queue_offline_from_kiosk)
        c2 = create(:queue_offline_from_kiosk, parent: c1)

        expect(c1.children).to include(c2)
        expect(c2.parent).to eq c1
      end
    end
  end

  describe "Achived queue" do
    context "given today queue inserted" do
      it "should save to backup queue" do
        today_queue = create(:queue_offline_from_kiosk)
        backup_queue = BackupQueue.first
        expect(today_queue.id).to eq backup_queue.id
      end
    end
  end

  describe "last queue" do
    context "there is one queue" do
      it "should return a queue" do
      end
    end
  end

  describe "last queue number" do
    context "there is one queue" do
      it "should return number 1" do
      end
    end
  end

  describe "last next queue number" do
    context "there is one queue" do
      it "should return number 2" do
      end
    end
  end

  describe "current queue" do
    context "there is one queue that called already" do
      it "should return number 1" do
      end
    end
  end

  # validates_datetime :print_ticket_time, on_or_after: :today
  # validates_date :date, on_or_after: :today
end
