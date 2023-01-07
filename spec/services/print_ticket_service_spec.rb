# frozen_string_literal: true

require "rails_helper"

RSpec.describe PrintTicketService, type: :service do
  before(:each) do
    t = Time.local(2022, 12, 12, 16, 0, 0)
    Timecop.travel(t)

    create(:counter)
    @company = Company.first
    @service = Service.first

    @print_ticket_at_kiosk = {print_ticket_location: :kiosk, service_id: @service.id}
    (1..6).each do |d|
      create(:working_day_for_company, workable: @company, day: d)
      create(:working_day_for_service, workable: @service, day: d)
    end
  end

  context "is_service_exists?" do
    it "add and error" do
      print_ticket = described_class.execute(service_id: 0)
      expect(print_ticket.errors.added?(:base, I18n.t(".service_not_found"))).to be true
    end
  end

  context "is_company_close_this_day?" do
    it "add and error" do
      ClosingDay.create(
        date: Time.current,
        closeable: @company,
        start_time: Time.current.change({hour: 8, min: 0, sec: 0}),
        finish_time: Time.current.change({hour: 18, min: 0, sec: 0})
      )

      print_ticket = described_class.execute(**@print_ticket_at_kiosk)

      expect(print_ticket.errors.added?(:base, I18n.t(".company_is_closed", value: Date.today.to_s))).to be true
    end
  end

  context "is_service_close_this_day?" do
    it "add and error" do
      t = Time.local(2022, 12, 14, 16, 0, 0)
      Timecop.travel(t)

      ClosingDay.create(
        date: Time.current,
        closeable: @service,
        start_time: Time.current.change({hour: 8, min: 0, sec: 0}),
        finish_time: Time.current.change({hour: 18, min: 0, sec: 0})
      )

      print_ticket = described_class.execute(**@print_ticket_at_kiosk)
      expect(print_ticket.errors.added?(:base, I18n.t(".service_is_closed", value: Date.today.to_s))).to be true
    end
  end

  context "is_service_temporary_closed?" do
    it "add and error" do
      t = Time.local(2022, 12, 15, 16, 0, 0)
      Timecop.travel(t)

      @service.update(closed: true)
      print_ticket = described_class.execute(**@print_ticket_at_kiosk)
      expect(print_ticket.errors.added?(:base, I18n.t(".service_temporary_closed", value: Date.today.to_s))).to be true
    end
  end

  context "is_company_working_this_day?" do
    it "add and error" do
      t = Time.local(2022, 12, 11, 16, 0, 0)
      Timecop.travel(t)

      print_ticket = described_class.execute(**@print_ticket_at_kiosk)
      expect(print_ticket.errors.added?(:base, I18n.t(".company_is_closed", value: Date::DAYNAMES[Date.today.wday]))).to be true
    end
  end

  context "is_service_working_this_day?" do
    it "add and error" do
      t = Time.local(2022, 12, 12, 16, 0, 0)
      Timecop.travel(t)

      WorkingDay.find_by(day: Date.today.wday, workable: @service).really_destroy!

      print_ticket = described_class.execute(**@print_ticket_at_kiosk)
      expect(print_ticket.errors.added?(:base, I18n.t(".service_is_closed", value: Date::DAYNAMES[Date.today.wday]))).to be true
    end
  end

  context "is_quota_exceed?" do
    it "add and error" do
      described_class.execute(**@print_ticket_at_kiosk)

      @service.update(max_quota: 1)

      print_ticket = described_class.execute(**@print_ticket_at_kiosk)

      expect(print_ticket.errors.added?(:base, I18n.t(".quota_is_exceed", max_quota: @service.max_quota))).to be true
    end
  end

  describe "Normal condition" do
    before {
      @print_ticket = described_class.execute(**@print_ticket_at_kiosk)
      @result = OpenStruct.new(@print_ticket.result)

      @print_ticket2 = described_class.execute(**@print_ticket_at_kiosk)
      @result2 = OpenStruct.new(@print_ticket2.result)
    }

    context "First time print" do
      it "success to add new queue" do
        expect(@print_ticket.success?).to be true
      end

      it "should contains expected values" do
        expect(@result.from).to eq(:server)
        expect(@result.action).to eq(:print_ticket)
        expect(@result.service_id).to eq(@service.id)
        expect(@result.counter_id).to eq(nil)
        expect(@result.total_queue_left).to eq(1)
        expect(@result.total_offline_queues).to eq(1)
        expect(@result.total_online_queues).to eq(0)
        expect(@result.missed_queues).to eq([])
        expect(@result.missed_queues_count).to eq(0)
        expect(@result.current_queue_in_counter_text).to eq(nil)
        expect(@result.play_voice_queue_text).to eq(nil)
        expect(@result.queue_number_to_print).to eq("#{@service.letter} 001")
      end
    end

    context "Second time print" do
      it "success to add new queue" do
        expect(@print_ticket2.success?).to be true
      end

      it "should contains expected values" do
        expect(@result2.from).to eq(:server)
        expect(@result2.action).to eq(:print_ticket)
        expect(@result2.service_id).to eq(@service.id)
        expect(@result2.counter_id).to eq(nil)
        expect(@result2.total_queue_left).to eq(2)
        expect(@result2.total_offline_queues).to eq(2)
        expect(@result2.total_online_queues).to eq(0)
        expect(@result2.missed_queues).to eq([])
        expect(@result2.missed_queues_count).to eq(0)
        expect(@result2.current_queue_in_counter_text).to eq(nil)
        expect(@result2.play_voice_queue_text).to eq(nil)
        expect(@result2.queue_number_to_print).to eq("#{@service.letter} 002")
      end
    end
  end
end
