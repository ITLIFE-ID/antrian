class MQTTSubscriber
  MQTT_CHANNEL = ENV["MQTT_CHANNEL"]

  def run
    Thread.new do
      Rails.application.config.mqtt_connect.get(MQTT_CHANNEL) do |topic, message|
        return nil unless MQTT_CHANNEL == topic
        data = JSON.parse(message)

        if ["caller", "kiosk"].include? data["from"]
          CallerService.execute({data: data})
        elsif data["from"] == "client_display"
          ClientConfigService.execute(data: data)
        end
      end
    end
  end
end
