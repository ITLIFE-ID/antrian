# frozen_string_literal: true

module Callers
  class RecallService < QueueService
    def execute
      may_i_recall_last_queue_in_my_counter?

      mqtt_publish!("RECALL")
    rescue => e
      errors.add(:recall_service, e.message)
    end

    private

    def may_i_recall_last_queue_in_my_counter?
      is_counter_exists?
      is_latest_queue_in_counter_available_to_recall?
    end
  end
end
