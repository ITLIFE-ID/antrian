import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
import "selectize"

export default class extends Controller {
  connect() {    
  $("#service").selectize()
  $('#counter').selectize({     
      onChange: function(value, isOnInitialize) {                           
        window.location.href="?counter_id="+value          
      }
    });
    $(".selectize-input").css("padding-top", "13px").css("padding-bottom", "14px").css("font-size", "18px");    
  }
}