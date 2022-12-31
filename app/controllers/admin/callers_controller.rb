# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

module Admin
  class CallersController < Admin::ApplicationController
    before_action :set_selected_counter, :set_today_queue
    add_breadcrumb I18n.t("caller")

    def index
      @counters = Counter.where(service: @current_company.services)
      @services = @current_company.services
      @current_queue = TodayQueue.where(counter: @selected_counter, attend: false).order(id: :desc).first
      @total_queue_left = @today_queues.count
      @offline_queues = TodayQueue.total_offline_queue.count
      @online_queues = TodayQueue.total_online_queue.count
    end

    def permitted_params
      params.permit(:today_queue_id, :service_id, :counter_id)
    end

    def set_today_queue
      @today_queues ||= TodayQueue
        .where(attend: false, service: @selected_counter&.service)
        .order(id: :asc)
    end

    def set_selected_counter
      @selected_counter ||= Counter.find_by(id: params[:counter_id])
    end
  end
end
