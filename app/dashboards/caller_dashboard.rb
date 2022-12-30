# app/dashboards/caller_dashboard.rb
require "administrate/custom_dashboard"

class CallerDashboard < Administrate::CustomDashboard
  resource "Caller" # used by administrate in the views
end
