import { Controller } from "@hotwired/stimulus"
import Paho from "paho-mqtt"

export default class extends Controller {
  connect() {    
    // Create a client instance
    var client = new Paho.Client("localhost", Number(8080), "Caller");    
    // set callback handlers
    client.onConnectionLost = onConnectionLost;
    client.onMessageArrived = onMessageArrived;

    // connect the client
    client.connect({onSuccess:onConnect});
    
    // called when the client connects
    function onConnect() {
      // Once a connection has been made, make a subscription and send a message.
      client.subscribe("QUEUE_SYSTEM");
      $("#mqtt-alert")
      .addClass("alert-success")
      .removeClass("alert-danger")
      .html("Berhasil konek ke server")      

      // message = new Paho.Message("Hello");
      // message.destinationName = "World";
      // client.send(message);
    }

    // called when the client loses its connection
    function onConnectionLost(responseObject) {
      if (responseObject.errorCode !== 0) {
        $("#mqtt-alert")
        .addClass("alert-danger")
        .removeClass("alert-success")
        .html("Koneksi gagal ke server, Mohon refresh browser")        
        console.log("onConnectionLost:"+responseObject.errorMessage);
      }
    }

    // called when a message arrives
    function onMessageArrived(message) {
      console.log("onMessageArrived:"+message.payloadString);
    }
  }
}