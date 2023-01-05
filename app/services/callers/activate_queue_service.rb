# frozen_string_literal: true

module Callers
  class ActivateQueueService < QueueService
    def execute
      # draft
      mqtt_publish!("activate_queue")
    end
  end
end
