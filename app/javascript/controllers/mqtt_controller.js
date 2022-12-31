import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import Paho from "paho-mqtt"
import Swal  from "sweetalert2"

export default class extends Controller {
  connect() {    
    // Create a client instance
    var MQTT_CHANNEL = "QUEUE_SYSTEM"
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
      client.subscribe(MQTT_CHANNEL);
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

        send_message(payload)
      });
      
      $(".recall").click(function(){
        const payload = {
          from : "caller",
          action: "recall",
          data: {
            id: current_queue_id            
          }
        }

        send_message(payload)
      });

      $("#transfer").click(function(){
        const payload = {
          from : "caller",
          action: "transfer",
          data: {
            id: current_queue_id,
            service_id: service_id,            
            transfer: true
          }
        }

        send_message(payload)
      });
    }

    function send_message(payload){
      const message = new Paho.Message(JSON.stringify(payload));
      message.destinationName = MQTT_CHANNEL;
      client.send(message);
      toast(payload)
    }

    function toast(payload){
      var Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000
      });
      
      Toast.fire({
        icon: 'success',
        title: payload["action"]
      })
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
      var current_service_id = parseInt($("#counter").attr("data-service-id"))

      var data = JSON.parse(message.payloadString)            
      if(data["action"] == "PRINT_TICKET"){                 
        if(current_service_id == data["service_id"]){           
          toast({action: "Ada antrian baru"})          
          $("#total_queue_left").html(data["total_queue_left"])  
        }        
      }
      // console.log("onMessageArrived:"+message.payloadString);
    }
  }
}