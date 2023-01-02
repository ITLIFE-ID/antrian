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
    var message = { from : "caller", action: "check_server", data: {counter_id: counter_id}}

    var client = new Paho.Client("localhost", Number(8080), Math.random().toString(36) + "web_caller_counter_"+counter_id);    
    // set callback handlers
    client.onConnectionLost = onConnectionLost;
    client.onMessageArrived = onMessageArrived;

    // connect the client
    client.connect({onSuccess:onConnect});
        
    function onConnect() {      
      client.subscribe(MQTT_CHANNEL);      
      
      check_server(message)

      $("#call").click(function(){        
        send_message($.extend({}, message, {action: "call"}))
      });
      
      $(".recall").click(function(){
        send_message($.extend({}, message, {action: "recall", data: {id: current_queue_id}}))        
      });

      $("#transfer").click(function(){
        let data = {
          action: "transfer",
          data: {
            id: current_queue_id,
            service_id: service_id,            
            transfer: true
          }
        }

        send_message($.extend({}, message, data))        
      });
    }

    function send_message(payload){
      const message = new Paho.Message(JSON.stringify(payload));
      message.destinationName = MQTT_CHANNEL;
      client.send(message);

      if(payload["action"] != "check_server"){
        toast("Process to "+payload["action"])
      }        
    }

    function check_server(message){
      $("#mqtt-alert")
      .addClass("alert-success")
      .removeClass("alert-danger")
      .html("Berhasil konek ke server")    

      send_message(message)
    }

    function toast(message, icon="success"){
      var Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000
      });
      
      Toast.fire({
        icon: icon,
        title: message
      })
    }
    
    // called when the client loses its connection
    function onConnectionLost(responseObject) {
      if (responseObject.errorCode !== 0) {
        $("#mqtt-alert")
        .addClass("alert-danger")
        .removeClass("alert-success")
        .html("Koneksi ke server gagal, Mohon refresh browser")        
        console.log("onConnectionLost:"+responseObject.errorMessage);
      }
    }

    // called when a message arrives
    function onMessageArrived(message) {
      var current_service_id = parseInt($("#counter").attr("data-service-id"))

      var data = JSON.parse(message.payloadString)   

      if(data["action"] == "PRINT_TICKET" || data["ACTION"] == "CALL"){                 
        if(current_service_id == data["service_id"]){                     
          $("#current_queue").html(data["current_queue_in_counter_text"])
          $("#total_queue_left").html(data["total_queue_left"])  
          $("#total_offline_queues").html(data["total_offline_queues"])  
          $("#total_online_queues").html(data["total_online_queues"])  
        }        
      }

      if(data["from"] == "server"){
        if(data["action"] == "receive"){
          let counter_id = $("#counter").attr("data-id")

          if(counter_id == data["to"]["counter_id"]){
            toast(data["message"], data["status"])
          }        
        }
        else if(data["action"] == "ready"){
          $("#server-alert")
          .addClass("alert-success")
          .removeClass("alert-danger")
          .html(data["message"])      
        }
      }

      console.log("onMessageArrived:"+message.payloadString);
    }
  }
}