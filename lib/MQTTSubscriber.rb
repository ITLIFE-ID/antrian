class MQTTSubscriber
  def run
    Thread.new do
      mqtt_connect do |c|
        publish_server_ready

        c.get(ENV["MQTT_CHANNEL"]) do |topic, message|
          return nil unless ENV["MQTT_CHANNEL"] == topic
          message = JSON.parse(message)

          if message["from"] == "caller"
            response = case message["action"]
            when "call"
              Callers::CallService.execute(message["data"])
            when "recall"
              Callers::RecallService.execute(message["data"])
            when "transfer"
              Callers::RecallService.execute(message["data"])
            else
              publish_server_ready(message["data"])
            end

            mqtt_callback(response, message)
          elsif message["from"] == "kiosk"
            # PrintTicketService.execute()
            mqtt_callback(response, message)
          end
        end
      end
    end
  end

  private

  def mqtt_callback(result, message)
    response = {from: "server", action: "receive", to: message["data"], status: "success"}
    content = if result.success?
      response.merge(message: "Berhasil #{message["action"]}")
    else
      response.merge(message: "Terjadi kesalahan sistem", status: "error")
    end

    mqtt_connect.publish(ENV["MQTT_CHANNEL"], content.to_json)
  end

  def publish_server_ready(to = nil)
    response = {from: "server", action: "server_ready", to: to, message: "Server siap menerima request", status: "success"}
    mqtt_connect.publish(ENV["MQTT_CHANNEL"], response.to_json)
  end

  def mqtt_connect
    MQTT::Client.connect(host: ENV.fetch("MQTT_HOST"), port: ENV.fetch("MQTT_PORT"))
  end
end
