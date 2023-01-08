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
    PrintTicketService.execute(print_ticket_location: :kiosk, service_id: @service)
    Callers::CallService.execute(counter_id: @counter)
    Callers::CallService.execute(counter_id: @counter)
  end

  context "is_counter_exists?" do
    it "add and error" do
      recall_queue = described_class.execute(action: "recall", counter_id: 0)
      expect(recall_queue.errors.added?(:base, I18n.t(".counter_not_found"))).to be true
    end
  end

  context "is_queue_still_available?" do
    it "add and error" do
      TodayQueue.first.update(attend: true, finish_time: Time.current)

      recall_queue = described_class.execute(action: "recall", counter_id: @counter)

      expect(recall_queue.errors.added?(:base, I18n.t(".last_queue_not_available_to_recall"))).to be true
    end
  end

  context "Normal condition" do
    before {
      @recall_queue = described_class.execute(action: "recall", counter_id: @counter.id, id: TodayQueue.first.id, service_id: @service.id)
      @result = OpenStruct.new(@recall_queue.result)
      @first_queue = TodayQueue.first
    }

    it "success to call next queue" do
      expect(@recall_queue.success?).to be true
    end

    it "should contains expected values" do
      expect(@result.from).to eq(:server)
      expect(@result.action).to eq(:recall)
      expect(@result.service_id).to eq(@service.id)
      expect(@result.counter_id).to eq(@counter.id)
      expect(@result.id).to eq(@first_queue.id)
      expect(@result.total_queue_left).to eq(0)
      expect(@result.total_offline_queues).to eq(2)
      expect(@result.total_online_queues).to eq(0)
      expect(@result.missed_queues.any?).to be true
      expect(@result.missed_queues_count).to eq(2)
      expect(@result.current_queue_in_counter_text).to eq("#{@service.letter} 001")
      expect(@result.play_voice_queue_text).to eq("NOMOR_ANTRIAN #{@service.letter} #{Terbilang.convert(@first_queue.number)&.upcase} SILAHKAN_MENUJU #{@service.service_type.slug} #{Terbilang.convert(@counter.number)&.upcase}")
      expect(@result.queue_number_to_print).to eq(nil)
    end
  end
end
