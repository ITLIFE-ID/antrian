# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

module Admin
  class CallersController < Admin::ApplicationController
    before_action :set_selected_counter
    add_breadcrumb I18n.t("caller")

    def index      
      @counters = Counter.where(service: @current_company.services)
      @services = @current_company.services
      @today_queues = TodayQueue.total_queue(@selected_counter&.service)
      @current_queue = TodayQueue.current_queue(@selected_counter).first      
      @total_queue_left = TodayQueue.total_queue_left(@selected_counter&.service).count
      @total_offline_queues = TodayQueue.total_offline_queue(set_selected_counter&.service).count
      @total_online_queues = TodayQueue.total_online_queue(set_selected_counter&.service).count      
    end

    def permitted_params
      params.permit(:today_queue_id, :service_id, :counter_id)
    end

    def set_selected_counter
      @selected_counter ||= Counter.find_by(id: params[:counter_id])
    end
  end
end
