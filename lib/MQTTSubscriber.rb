class MQTTSubscriber
  MQTT_CHANNEL = ENV["MQTT_CHANNEL"]

  def run
    Thread.new do
      Rails.application.config.mqtt_connect.get(MQTT_CHANNEL) do |topic, message|
        return nil unless MQTT_CHANNEL == topic
        data = JSON.parse(message)

        CallerService.execute({data: data}) if ["caller", "kiosk"].include? data["from"]
      end
    end
  end
end
