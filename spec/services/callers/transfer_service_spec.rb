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
    it "success to add tramsfer queue" do
      transfer = described_class.execute(id: TodayQueue.first, service_id: @service2, transfer: 1)
      expect(transfer.success?).to be true
    end
  end
end
