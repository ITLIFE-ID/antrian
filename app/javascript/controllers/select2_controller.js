import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
import "select2"

export default class extends Controller {
  connect() {    
    $('.select2').select2()
  }
}