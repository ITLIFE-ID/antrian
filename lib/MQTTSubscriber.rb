class MQTTSubscriber
  def run
    Thread.new do
      MQTT::Client.connect(host: ENV.fetch("MQTT_HOST"), port: ENV.fetch("MQTT_PORT")) do |c|
        # If you pass a block to the get method, then it will loop
        c.get(ENV["MQTT_CHANNEL"]) do |topic, message|
          return unless ENV["MQTT_CHANNEL"] == topic
          message = JSON.parse(message)

          if message["from"] == "caller"
            Callers::CallService.execute(message["data"]) if message["action"] == "call"
            Callers::RecallService.execute(message["data"]) if message["action"] == "recall"
            Callers::RecallService.execute(message["data"]) if message["action"] == "transfer"
          elsif message["from"] == "kiosk"
            # PrintTicketService.execute()
          end
          puts "#{topic}: #{message}"
        end
      end
    end
  end
end
