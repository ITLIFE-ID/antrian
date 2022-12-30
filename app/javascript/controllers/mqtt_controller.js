import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import Paho from "paho-mqtt"

export default class extends Controller {
  connect() {    
    // Create a client instance
    var topic = "QUEUE_SYSTEM"
    var counter_id = $("#counter").attr("data-id")
    var service_id = $("#service").val()
    var current_queue_id = $("#current_queue").attr("data-id")
    var client = new Paho.Client("localhost", Number(8080), "web_caller_counter_"+counter_id);    
    // set callback handlers
    client.onConnectionLost = onConnectionLost;
    client.onMessageArrived = onMessageArrived;

    // connect the client
    client.connect({onSuccess:onConnect});
    
    // called when the client connects
    function onConnect() {
      // Once a connection has been made, make a subscription and send a message.
      client.subscribe(topic);
      $("#mqtt-alert")
      .addClass("alert-success")
      .removeClass("alert-danger")
      .html("Berhasil konek ke server")      

      $("#call").click(function(){
        const payload = {
          from : "caller",
          action: "call",
          data: {
            counter_id: counter_id
          }
        }
        var message = new Paho.Message(JSON.stringify(payload));
        message.destinationName = topic;
        client.send(message);
      });
      
      $("#recall").click(function(){
        const payload = {
          from : "caller",
          action: "recall",
          data: {
            current_queue_id: current_queue_id,
            service_id: service_id
          }
        }
        var message = new Paho.Message(JSON.stringify(payload));
        message.destinationName = topic;
        client.send(message);
      });

      $("#switch").click(function(){
        const payload = {
          from : "caller",
          action: "switch",
          data: {
            service_id: service_id,
            current_queue_id: current_queue_id
          }
        }
        
        var message = new Paho.Message(JSON.stringify(payload));
        message.destinationName = topic;
        client.send(message);
      });
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