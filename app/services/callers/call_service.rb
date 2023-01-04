# frozen_string_literal: true

module Callers
  class CallService < QueueService
    def execute
      may_i_call_next_queue?

      last_queue_in_counter.first.update(finish_time: Time.current, attend: user_attend_to_counter, process_duration: process_duration) if last_queue_in_counter.present?

      available_queue_to_call.update(counter: counter, start_time: Time.current)

      mqtt_publish!("CALL")
    rescue => e
      return_errors(e)
    end

    private

    def may_i_call_next_queue?
      is_counter_exists?
      is_queue_still_available?
    end

    def process_duration
      (Time.current - last_queue_in_counter.first.start_time)
    end
  end
end
