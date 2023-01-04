import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import Paho from "paho-mqtt"
import Swal  from "sweetalert2"

export default class extends Controller {
  connect() {    
    // Create a client instance
    const MQTT_CHANNEL = "QUEUE_SYSTEM"
    const counter_id = $("#counter").attr("data-id")        
    const message = { from : "caller", action: "check_server", data: {counter_id: counter_id}}
    const current_service_id = parseInt($("#counter").attr("data-service-id"))
    const date = $("#date").val()

    const client = new Paho.Client("localhost", Number(8080), Math.random().toString(36) + "web_caller_counter_"+counter_id);    
    // set callback handlers
    client.onConnectionLost = onConnectionLost;
    client.onMessageArrived = onMessageArrived;

    // connect the client
    client.connect({onSuccess:onConnect});
        
    function onConnect() {      
      client.subscribe(MQTT_CHANNEL);      
      
      check_server(message)

      $("#call").click(function(){  
        if($('#current_queue').attr("data-id") != ""){          
          Swal.fire({
            title: 'Apakah hadir di loket?',          
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Hadir'
          }).then((result) => {
            if (result.isConfirmed) { 
              send_message($.extend({}, message, {action: "call", data: {counter_id: counter_id, attend: true}}))
            }
            send_message($.extend({}, message, {action: "call", data: {counter_id: counter_id, attend: false}}))
          })      
        }
        else{
          send_message($.extend({}, message, {action: "call", data: {counter_id: counter_id, attend: null}}))
        }        
      });
      
      $(".recall").click(function(){
        const current_queue_id = $("#current_queue").attr("data-id")
        send_message($.extend({}, message, {action: "recall", data: {id: current_queue_id, counter_id: counter_id}}))        
      });

      $("#transfer").click(function(){
        const service_id = $("#service").val()
        const current_queue_id = $("#current_queue").attr("data-id")

        let data = {
          action: "transfer",
          data: {
            id: current_queue_id,
            service_id: service_id,            
            transfer: true,
            counter_id: counter_id
          }
        }

        send_message($.extend({}, message, data))        
      });

      $("#print_ticket").click(function(){
        const service_id = $("#service").val()
        const counter_id = $("#counter").attr("data-id") 

        if(counter_id == "")
          return alert("Pilih counter")
          
        let data = {
          action: "print_ticket",
          data: {            
            service_id: service_id,            
            date: date,
            print_ticket_location: "counter"
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

    function change_status(element, message){
      $(element)
      .addClass("alert-success")
      .removeClass("alert-danger")
      .html(message)
    }

    function check_server(message){      
      change_status("#mqtt-alert", "Berhasil konek ke server")
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
        change_status("#mqtt-alert", "Koneksi ke server gagal, Mohon refresh browser")      
        console.log("onConnectionLost:"+responseObject.errorMessage);
      }
    }

    // called when a message arrives
    function onMessageArrived(message) {      
      const data = JSON.parse(message.payloadString)
      const action = data["action"]
      const from = data["from"]
                     
      if(current_service_id == data["service_id"]){                            
        if(action == "CALL"){
          $("#current_queue").html(data["current_queue_in_counter_text"])
        }
        else if(action == "PRINT_TICKET"){  
          $("#total_queue_left").html(data["total_queue_left"])  
          $("#total_offline_queues").html(data["total_offline_queues"])  
          $("#total_online_queues").html(data["total_online_queues"])  
          $("#missed_queues").html(data["missed_queues"])
        }        
      }

      if(from == "server"){                
        let to_counter_id =  data["to"]["counter_id"]

        if(action == "receive"){          
          if(counter_id == to_counter_id){
            toast(data["message"], data["status"])
          }        
        }
        else if(action == "ready"){
          change_status("#server-alert", data["message"]) 
        }
      }

      console.log("onMessageArrived:"+message.payloadString);
    }
  }
}