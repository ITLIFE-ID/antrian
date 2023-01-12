class MQTTSubscriber  
  MQTT_CHANNEL = ENV["MQTT_CHANNEL"]

  def run
    Thread.new do
      Rails.application.config.mqtt_connect.get(MQTT_CHANNEL) do |topic, message|
        return unless MQTT_CHANNEL == topic                
        CallerService.execute({data: message})
      end    
    end
  end  
end
