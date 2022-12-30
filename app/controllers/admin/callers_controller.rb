# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

module Admin
  class CallersController < Admin::ApplicationController
    before_action :set_today_queue
    def index
      @services = @current_company.services
      @counters = Counter.where(service: @services)
      @current_queue = TodayQueue.where(counter_id: permitted_params[:counter_id]).order(id: :desc).first
      @waiting_queues = @today_queues.count
      @offline_queues = TodayQueue.total_offline_queue.count
      @online_queues = TodayQueue.total_offline_queue.count
    end

    def permitted_params
      params.permit(:today_queue_id, :service_id, :counter_id)
    end

    def set_today_queue
      @today_queues ||= TodayQueue.where(service_id: permitted_params[:service_id])
    end
  end
end
