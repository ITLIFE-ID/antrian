# frozen_string_literal: true

require "rails_helper"

RSpec.describe PrintTicketService, type: :service do
  before(:each) do
    t = Time.local(2022, 12, 12, 16, 0, 0)
    Timecop.travel(t)

    FactoryBot.create(:counter)
    @company = Company.first
    @service = Service.first

    @print_ticket_at_kiosk = {print_ticket_location: :kiosk, service_id: @service}
    (1..6).each do |d|
      FactoryBot.create(:working_day_for_company, workable: @company, day: d)
      FactoryBot.create(:working_day_for_service, workable: @service, day: d)
    end
  end

  context "is_service_exists?" do
    it "add and error" do
      print_ticket = described_class.execute(service_id: 0)
      expect(print_ticket.errors.added?(:print_ticket_service, I18n.t(".service_not_found"))).to be true
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
          
      expect(print_ticket.errors.added?(:print_ticket_service, I18n.t(".company_is_closed", value: Date.today.to_s))).to be true
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
      expect(print_ticket.errors.added?(:print_ticket_service, I18n.t(".service_is_closed", value: Date.today.to_s))).to be true
    end
  end

  context "is_service_temporary_closed?" do
    it "add and error" do
      t = Time.local(2022, 12, 15, 16, 0, 0)
      Timecop.travel(t)

      @service.update(closed: true)
      print_ticket = described_class.execute(**@print_ticket_at_kiosk)
      expect(print_ticket.errors.added?(:print_ticket_service, I18n.t(".service_temporary_closed", value: Date.today.to_s))).to be true
    end
  end

  context "is_company_working_this_day?" do
    it "add and error" do
      t = Time.local(2022, 12, 11, 16, 0, 0)
      Timecop.travel(t)

      print_ticket = described_class.execute(**@print_ticket_at_kiosk)
      expect(print_ticket.errors.added?(:print_ticket_service, I18n.t(".company_is_closed", value: Date::DAYNAMES[Date.today.wday]))).to be true
    end
  end

  context "is_service_working_this_day?" do
    it "add and error" do
      t = Time.local(2022, 12, 12, 16, 0, 0)
      Timecop.travel(t)

      WorkingDay.find_by(day: Date.today.wday).destroy

      print_ticket = described_class.execute(**@print_ticket_at_kiosk)      
      expect(print_ticket.errors.added?(:print_ticket_service, I18n.t(".service_is_closed", value: Date::DAYNAMES[Date.today.wday]))).to be true
    end
  end

  context "is_quota_exceed?" do
    it "add and error" do
      described_class.execute(**@print_ticket_at_kiosk)

      @service.update(max_quota: 1)

      print_ticket = described_class.execute(**@print_ticket_at_kiosk)

      expect(print_ticket.errors.added?(:print_ticket_service, I18n.t(".quota_is_exceed", max_quota: @service.max_quota))).to be true
    end
  end

  context "Normal condition" do
    it "success to add new queue" do
      print_ticket = described_class.execute(service_id: @service)
      expect(print_ticket.success?).to be true
    end
  end
end
