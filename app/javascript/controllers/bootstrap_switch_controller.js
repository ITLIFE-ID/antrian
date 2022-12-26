import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
import "bootstrap-switch"

export default class extends Controller {
  connect() {    
    $(".bootstrap-swotch").each(function(){
      $(this).bootstrapSwitch('state', $(this).prop('checked'));
    })
  }
}