class CallerService < ApplicationService  
  MQTT_CHANNEL = ENV["MQTT_CHANNEL"]
  attr_accessor :data
  
  def execute        
    message_as_json = JSON.parse(data)
    message = OpenStruct.new(message_as_json)

    if ["caller", "kiosk"].include? message.from
      response = case message.action
      when "print_ticket"
        PrintTicketService.execute(message_as_json)
      when "call"
        Callers::CallService.execute(message_as_json)
      when "recall"
        Callers::RecallService.execute(message_as_json)
      when "transfer"
        Callers::TransferService.execute(message_as_json)
      when "check_server"
        publish_server_ready(message)
      end

      mqtt_callback(response, message) unless message.action == "check_server"
    end
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