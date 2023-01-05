class MQTTSubscriber
  def run
    Thread.new do
      Rails.application.config.mqtt_connect.get(ENV["MQTT_CHANNEL"]) do |topic, message|
        return nil unless ENV["MQTT_CHANNEL"] == topic
        message = OpenStruct.new(JSON.parse(message))

        if message.from == "caller"
          response = case message.action
          when "call"
            Callers::CallService.execute(message)
          when "recall"
            Callers::RecallService.execute(message)
          when "transfer"
            Callers::RecallService.execute(message)
          when "check_server"
            publish_server_ready(message.counter_id)
          end

          mqtt_callback(response, message)
        elsif message.from == "kiosk"
          # PrintTicketService.execute()
          mqtt_callback(response, message)
        end
      end
    end
  end

  private

  def mqtt_callback(result, message)
    return if result.blank?
    response = {from: :server, action: :receive, to: message["data"], status: :success}
    content = if result.success?
      response.merge(message: "Berhasil #{message["action"]}")
    else
      response.merge(message: result.error_messages, status: "error")
    end

    Rails.application.config.mqtt_connect.publish(ENV["MQTT_CHANNEL"], content.to_json)
  end

  def publish_server_ready(to = nil)
    response = {from: :server, action: :ready, to: to, message: "Server siap menerima request", status: :success}
    Rails.application.config.mqtt_connect.publish(ENV["MQTT_CHANNEL"], response.to_json)
  end
end
