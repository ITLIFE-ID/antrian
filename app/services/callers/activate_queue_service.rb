# frozen_string_literal: true

module Callers
  class ActivateQueueService < QueueService
    def execute
      # draft
      mqtt_publish!("ACTIVATE_QUEUE")
    end
  end
end
