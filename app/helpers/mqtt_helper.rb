module MqttHelper
  def self.publish(mqtt_channel, message)
    Rails.application.config.mqtt_connect.publish(mqtt_channel, message.to_json)
  end
end