# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

module Admin
  class CallersController < Admin::ApplicationController
    before_action :set_counters, :set_counter_name, :set_today_queue
    add_breadcrumb I18n.t("caller")

    def index
      @services = @current_company.services
      @current_queue = TodayQueue.where(counter: selected_counter, attend: false).order(id: :desc).first
      @waiting_queues = @today_queues.count
      @offline_queues = TodayQueue.total_offline_queue.count
      @online_queues = TodayQueue.total_offline_queue.count
    end

    def permitted_params
      params.permit(:today_queue_id, :service_id, :counter_id)
    end

    def set_today_queue
      @today_queues ||= TodayQueue.where(service: selected_counter.service, attend: false).order(id: :asc)
    end

    def set_counters
      @counters ||= Counter.where(service: @current_company.services)
    end

    def selected_counter
      Counter.find_by(id: params[:counter_id]) || @counters.first
    end

    def set_counter_name
      @counter_name ||= "#{selected_counter.service.name} / Loket No. #{selected_counter.number}"
    end
  end
end
