# frozen_string_literal: true

require "rails_helper"

RSpec.describe Callers::TransferService, type: :service do
  before(:each) do
    t = Time.local(2022, 12, 12, 16, 0, 0)
    Timecop.travel(t)

    @counter = create(:counter)
    @company = Company.first
    @service = Service.first
    @service.update(letter: "A")
    @service2 = create(:service, company: Company.first, letter: "B")

    (1..6).each do |d|
      create(:working_day_for_company, workable: @company, day: d)
      create(:working_day_for_service, workable: @service, day: d)
      create(:working_day_for_service, workable: @service2, day: d)
    end

    @first_queue = PrintTicketService.execute(print_ticket_location: :kiosk, service_id: @service)
    PrintTicketService.execute(print_ticket_location: :kiosk, service_id: @service)
    Callers::CallService.execute(counter_id: @counter)
  end

  context "is_queue_exists?" do
    it "add and error" do
      transfer = described_class.execute(id: 0, service_id: @service2, counter_id: @counter, transfer: 1)
      expect(transfer.errors.added?(:base, I18n.t(".queue_not_found"))).to be true
    end
  end

  context "is_service_exists?" do
    it "add and error" do
      transfer = described_class.execute(id: TodayQueue.first, service_id: 0, counter_id: @counter, transfer: 1)
      expect(transfer.errors.added?(:base, I18n.t(".service_not_found"))).to be true
    end
  end

  context "is_service_close_this_day?" do
    it "add and error" do
      ClosingDay.create(
        date: Time.current,
        closeable: @service2,
        start_time: Time.current.change({hour: 8, min: 0, sec: 0}),
        finish_time: Time.current.change({hour: 18, min: 0, sec: 0})
      )

      transfer = described_class.execute(id: TodayQueue.first, service_id: @service2, transfer: 1)
      expect(transfer.errors.added?(:base, I18n.t(".service_is_closed", value: Date.today.to_s))).to be true
    end
  end

  context "is_service_temporary_closed?" do
    it "add and error" do
      ClosingDay.create(
        date: Time.current,
        closeable: @service2,
        start_time: Time.current.change({hour: 8, min: 0, sec: 0}),
        finish_time: Time.current.change({hour: 18, min: 0, sec: 0})
      )

      transfer = described_class.execute(id: TodayQueue.first, service_id: @service2, transfer: 1)
      expect(transfer.errors.added?(:base, I18n.t(".service_is_closed", value: Date.today.to_s))).to be true
    end
  end

  context "Normal condition" do
    before {
      @transfer = described_class.execute(id: TodayQueue.first.id, service_id: @service2.id, transfer: true)
      @result = OpenStruct.new(@transfer.result)
    }
    it "success to add new queue" do
      expect(@transfer.success?).to be true
    end

    it "should contains expected values" do
      expect(@result.from).to eq(:server)
      expect(@result.action).to eq(:transfer)
      expect(@result.service_id).to eq(@service2.id)
      expect(@result.counter_id).to eq(nil)
      expect(@result.total_queue_left).to eq(1)
      expect(@result.total_offline_queues).to eq(1)
      expect(@result.total_online_queues).to eq(0)
      expect(@result.missed_queues.any?).to be false
      expect(@result.missed_queues_count).to eq(0)
      expect(@result.current_queue_in_counter_text).to eq(nil)
      expect(@result.play_voice_queue_text).to eq(nil)
      expect(@result.queue_number_to_print).to eq(nil)
      expect(TodayQueue.count).to eq(3)
      expect(TodayQueue.last.service).to eq(@service2)
    end
  end
end
