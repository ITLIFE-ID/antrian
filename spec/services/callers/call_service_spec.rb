# frozen_string_literal: true

require "rails_helper"

RSpec.describe Callers::CallService, type: :service do
  before(:each) do
    t = Time.local(2022, 12, 12, 16, 0, 0)
    Timecop.travel(t)

    @counter = FactoryBot.create(:counter)
    @company = Company.first
    @service = Service.first

    (1..6).each do |d|
      FactoryBot.create(:company_working_day, workable: @company, day: d)
      FactoryBot.create(:service_working_day, workable: @service, day: d)
    end

    PrintTicketService.execute(print_ticket_location: :kiosk, service_id: @service)
  end

  context "is_counter_exists?" do
    it "add and error" do
      call_queue = described_class.execute(counter_id: 0)
      expect(call_queue.errors.added?(:call_service, I18n.t(".counter_not_found"))).to be true
    end
  end

  context "is_queue_still_available?" do
    it "add and error" do
      described_class.execute(counter_id: @counter)

      call_queue = described_class.execute(counter_id: @counter)

      expect(call_queue.errors.added?(:call_service, I18n.t(".queue_is_not_available"))).to be true
    end
  end

  context "Normal condition" do
    it "success to call next queue" do
      call_queue = described_class.execute(counter_id: @counter)
      expect(call_queue.success?).to be true
    end
  end
end
