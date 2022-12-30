import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
import "selectize"

export default class extends Controller {
  connect() {    
  $(".selectize").selectize()
  }
}