# frozen_string_literal: true

module MqttHelper
  def mqtt_client
    MQTT::Client.connect(host: ENV.fetch("MQTT_HOST"), port: ENV.fetch("MQTT_PORT"))
  rescue
    errors.add(:base, :host_isnt_active)
  end
end
