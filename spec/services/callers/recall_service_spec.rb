# frozen_string_literal: true

require "rails_helper"

RSpec.describe Callers::RecallService, type: :service do
  before(:each) do
    t = Time.local(2022, 12, 12, 16, 0, 0)
    Timecop.travel(t)

    @counter = create(:counter)
    @company = Company.first
    @service = Service.first

    (1..6).each do |d|
      create(:working_day_for_company, workable: @company, day: d)
      create(:working_day_for_service, workable: @service, day: d)
    end

    PrintTicketService.execute(print_ticket_location: :kiosk, service_id: @service)
    Callers::CallService.execute(counter_id: @counter)
  end

  context "is_counter_exists?" do
    it "add and error" do
      recall_queue = described_class.execute(counter_id: 0)
      expect(recall_queue.errors.added?(:recall_service, I18n.t(".counter_not_found"))).to be true
    end
  end

  context "is_queue_still_available?" do
    it "add and error" do
      TodayQueue.first.update(attend: true, finish_time: Time.current)

      recall_queue = described_class.execute(counter_id: @counter)

      expect(recall_queue.errors.added?(:recall_service, I18n.t(".last_queue_not_available_to_recall"))).to be true
    end
  end

  context "Normal condition" do
    it "success to call next queue" do
      recall_queue = described_class.execute(counter_id: @counter)
      expect(recall_queue.success?).to be true
    end
  end
end
