class CallerService < ApplicationService
  MQTT_CHANNEL = ENV["MQTT_CHANNEL"]
  attr_accessor :data

  def execute
    message = OpenStruct.new(data)

    response = case message.action
    when "print_ticket"
      PrintTicketService.execute(data)
    when "call"
      Callers::CallService.execute(data)
    when "recall"
      Callers::RecallService.execute(data)
    when "transfer"
      Callers::TransferService.execute(data)
    when "check_server"
      publish_server_ready(message)
    end

    mqtt_callback(response, message) unless message.action == "check_server"
  end

  private

  def mqtt_callback(result, message)
    message = {
      from: :server,
      action: :receive,
      service_id: message.service_id,
      counter_id: message.counter_id,
      status: :success,
      message: "Berhasil #{message.action.humanize}"
    }

    message = message.merge(message: result.error_messages, status: "error") unless result.success?
    MqttHelper.publish(MQTT_CHANNEL, message)
  end

  def publish_server_ready(message)
    message = {
      from: :server,
      action: :ready,
      service_id: message.service_id,
      counter_id: message.counter_id,
      message: "Server siap menerima request",
      status: :success
    }

    MqttHelper.publish(MQTT_CHANNEL, message)
  end
end
