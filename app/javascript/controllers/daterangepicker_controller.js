import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
import moment from "daterangepicker/moment.min"
import "daterangepicker"

export default class extends Controller {
  connect() {         
    $('#daterangepicker').daterangepicker(
      {
        ranges   : {
          // 'Today'       : [moment(), moment()],
          // 'Yesterday'   : [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
          // 'Last 7 Days' : [moment().subtract(6, 'days'), moment()],
          // 'Last 30 Days': [moment().subtract(29, 'days'), moment()],
          'This Month'  : [moment().startOf('month'), moment().endOf('month')],
          'Last Month'  : [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        },
        startDate: moment().subtract(29, 'days'),
        endDate  : moment()
      },
      function (start, end) {        
        window.location.href = "?start_date="+start.format('D-MM-YYYY')+"&end_date="+end.format('D-MM-YYYY')
        $('#reportrange').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'))
      }
    )
  }
}