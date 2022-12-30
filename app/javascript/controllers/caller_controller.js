import { Controller } from "@hotwired/stimulus"
import mqtt from "mqtt"

export default class extends Controller {
  connect() {    
    const client  = mqtt.connect('mqtt://localhost:1883')
    
    client.on('connect', function () {
      client.subscribe('QUEUE_SYSTEM', function (err) {
        if (!err) {
          console.log("Mqtt","OK")
          console.log("Subscribe", "QUEUE_SYSTEM")
        }
      })
    })
    
    client.on('message', function (topic, message) {
      // message is Buffer
      console.log("Topic", topic)
      message.toString("Message", message)
      client.end()
    })
  }
}