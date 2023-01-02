class MQTTSubscriber
  def run
    Thread.new do
      MQTT::Client.connect(host: ENV.fetch("MQTT_HOST"), port: ENV.fetch("MQTT_PORT")) do |c|
        # If you pass a block to the get method, then it will loop

        c.publish(ENV["MQTT_CHANNEL"], {from: "server", action: "SERVER_READY", message: "SERVER SIAP MENERIMA AKSI"}.to_json)

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
              "Forbiden action"
            end

            mqtt_callback(response, message)
          elsif message["from"] == "kiosk"
            # PrintTicketService.execute()
          end
        end
      end
    end
  end

  private

  def mqtt_callback(result, message)
    content = if result.success?
      {from: "server", action: "receive", source: message["data"], message: "Berhasil #{message["action"]}", status: "success"}
    else
      {from: "server", action: "receive", source: message["data"], message: "TERJADI KESALAHAN", status: "error"}

    end

    MQTT::Client.connect(host: ENV.fetch("MQTT_HOST"), port: ENV.fetch("MQTT_PORT")) do |c|
      c.publish(ENV["MQTT_CHANNEL"], content.to_json)
    end
  end
end
