# app/dashboards/dashboard_dashboard.rb
require "administrate/custom_dashboard"

class DigitalReceiptDashboard < Administrate::CustomDashboard
  resource "DigitalReceipt" # used by administrate in the views
end
