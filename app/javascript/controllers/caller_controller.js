import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
import "selectize"
import Pikaday from "pikaday"
export default class extends Controller {
  connect() {   
  var picker = new Pikaday(
    {
        field: document.getElementById('date'),
        firstDay: 1,
        minDate: new Date(),
        maxDate: new Date(2020, 12, 31),
        yearRange: [2000,2020]
    });
  $("#service").selectize()    
  $('#counter').selectize({     
      onChange: function(value, isOnInitialize) {                            
        window.location.href="?counter_id="+value          
      },
      create: true
    });
    $(".selectize-input").css("padding-top", "13px").css("padding-bottom", "14px").css("font-size", "18px");    
  }
}