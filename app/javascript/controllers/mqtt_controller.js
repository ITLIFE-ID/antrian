import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import Paho from "paho-mqtt"
import Swal  from "sweetalert2"

export default class extends Controller {
  connect() {    
    // Create a client instance
    const MQTT_CHANNEL = "QUEUE_SYSTEM"
    const counter_id = $("#counter").attr("data-id")            
    const service_id = parseInt($("#counter").attr("data-service-id"))    

    const client = new Paho.Client("localhost", Number(8080), Math.random().toString(36) + "web_caller_from_counter_"+counter_id);    
    // set callback handlers
    client.onConnectionLost = onConnectionLost;
    client.onMessageArrived = onMessageArrived;

    // connect the client
    client.connect({onSuccess:onConnect});
        
    function onConnect() {      
      client.subscribe(MQTT_CHANNEL);      
      
      check_server()

      $("#call").click(function(){  
        let current_queue = $("#current_queue")
        if(current_queue.attr("data-id") == ""){
          return send_message("call", {attend: null})
        }
        
        Swal.fire({
          title: 'Apakah antrian '+current_queue.html()+' hadir di loket?',          
          icon: 'question',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'Ya',
          cancelButtonText: 'Tidak'
        }).then((result) => {
          if (result.isConfirmed) send_message("call", {attend: true})            
          else send_message("call", {attend: false})
        })             
      });
      
      $(".recall").click(function(){
        send_message("recall", {id: $(this).attr("data-id")})
      });

      $("#transfer").click(function(){  
        let current_queue = $("#current_queue").html()
        let service_name = $("#service option:selected").text()
        let date = $("#date").val()
        Swal.fire({
          title: 'Apakah antrian '+current_queue+ " akan di pindahkan ke layanan "+service_name+" pada tanggal "+date,          
          icon: 'question',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'Ya',
          cancelButtonText: 'Tidak'
        }).then((result) => {
          if (result.isConfirmed) send_message("transfer", {transfer: true})          
        })   

        
      });

      $("#print_ticket").click(function(){
        if(counter_id == "") return alert("Pilih counter")
          
        let data = {         
          date: $("#date").val(),
          print_ticket_location: "counter"
        }

        send_message("print_ticket",data)
      });
    }
    
    // called when the client loses its connection
    function onConnectionLost(responseObject){
      if (responseObject.errorCode !== 0) {
        change_status("#mqtt-alert", "Koneksi ke server gagal, Mohon refresh browser")
      }
    }

    // called when a message arrives
    function onMessageArrived(message){
      const data = JSON.parse(message.payloadString)
      if(data.from == "server"){
        if(service_id == data.service_id){
          if(data.action != "transfer"){
            $("#total_queue_left").html(data.total_queue_left)
            $("#total_offline_queues").html(data.total_offline_queues)
            $("#total_online_queues").html(data.total_online_queues)          
            $("#missed_queues").html(data.missed_queues)
            $("#missed_queues_count").html(data.missed_queues_count)            
          }          
          
          if(counter_id == data.counter_id){
            if(data.action == "ready" ) {
              change_status("#server-alert", data.message)
            }
            else if(data.action == "print_ticket"){
              if(data.unique_number != "" || data.unique_number != null){
                window.open("digital_receipts?unique_number="+data.unique_number)                
              }
            }
            else{
              $("#recall").attr("data-id", data.id)
              $("#current_queue").html(data.current_queue_in_counter_text)
              $("#current_queue").attr("data-id", data.id)              
            }        
          }
        }  
        
        toast(data.message, data.status)
      }

      console.log("onMessageArrived:"+message.payloadString);
    }

    function send_message(action, payload){      
      const queue_id = $("#current_queue").attr("data-id")
      const counter_id = $("#counter").attr("data-id") 
      const target_service_id = action == "transfer" ? $("#service").val() : service_id
      const date = action == "transfer" ? $("#date").val() : null

      const data = {
        from: "caller",
        action: action,
        id: queue_id,
        counter_id: counter_id,
        service_id: target_service_id,
        date: date          
      }

      const message = new Paho.Message(JSON.stringify($.extend({}, data, payload)));
      message.destinationName = MQTT_CHANNEL;
      client.send(message);

      console.log("send_message", JSON.stringify($.extend({}, data, payload)))

      if(action != "check_server") toast("Process to "+action)      
    }

    function change_status(element, message, status = "success"){
      if(status == "success"){
        $(element)
          .addClass("alert-success")
          .removeClass("alert-danger")
          .html(message)
      }
      else{
        $(element)
          .addClass("alert-danger")
          .removeClass("alert-success")
          .html(message)
      }
      
    }

    function check_server(){            
      change_status("#mqtt-alert", "Berhasil konek ke server")      
      send_message("check_server", {})
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
  }
}