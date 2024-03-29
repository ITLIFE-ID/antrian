// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"
import BootstrapSwitchController from "./bootstrap_switch_controller"
import HelloController from "./hello_controller"
import DateRangePickerController from "./daterangepicker_controller"
import CallerController from "./caller_controller"
import MqttController from "./mqtt_controller"
import SelectizeController from "./selectize_controller"

application.register("hello", HelloController)
application.register("bootstrap-switch", BootstrapSwitchController)
application.register("daterangepicker", DateRangePickerController)
application.register("caller", CallerController)
application.register("mqtt", MqttController)
application.register("selectize", SelectizeController)
