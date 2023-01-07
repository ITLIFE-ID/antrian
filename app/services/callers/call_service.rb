# frozen_string_literal: true

module Callers
  class CallService < QueueService
    def execute
      may_i_call_next_queue?

      if find_queue_by_id.present?
        find_queue_by_id
          .update!(finish_time: Time.current,
            attend: user_attend_to_counter,
            process_duration: process_duration)
      end

      available_queue_to_call.update(counter: counter, start_time: Time.current)

      @result = mqtt_publish!("call")
    rescue => e
      return_errors(e)
    end

    private

    def may_i_call_next_queue?
      is_counter_exists?
      is_queue_still_available?
    end

    def process_duration
      (Time.current - find_queue_by_id.start_time).to_i
    end
  end
end
