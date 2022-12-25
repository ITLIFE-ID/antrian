# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

# app/controllers/admin/stats_controller.rb
module Admin
  class DashboardsController < Admin::ApplicationController
    before_action :set_type, :set_summary_title
    before_action :set_user_satisfaction_index_summary
    add_breadcrumb "Dashboard"

    def index
      send(@type)
    end

    def past
      @summary = [
        {name: t("past_queue_performance"), value: "5 antrian / menit", color: "bg-success", detail_path: admin_today_queues_path, skip_pie_chart: true},
        {name: t("total_queues"), value: BackupQueue.count, color: "bg-primary", detail_path: admin_today_queues_path, skip_pie_chart: true},
        {name: t("total_offline_queue"), value: BackupQueue.total_offline_queue.count, color: "bg-info", detail_path: admin_today_queues_path},
        {name: t("total_online_queue"), value: BackupQueue.total_online_queue.count, color: "bg-success", detail_path: admin_today_queues_path}
      ]

      build_summary

      render "index"
    end

    def today
      @summary = [
        {name: t("total_queues"), value: TodayQueue.total_queue.count, color: "bg-dark", detail_path: admin_today_queues_path},
        {name: t("total_processed"), value: TodayQueue.total_processed.count, color: "bg-primary", detail_path: admin_today_queues_path},
        {name: t("total_unprocessed"), value: TodayQueue.total_unprocessed.count, color: "bg-warning", detail_path: admin_today_queues_path},
        {name: t("total_offline_queue"), value: TodayQueue.total_offline_queue.count, color: "bg-info", detail_path: admin_today_queues_path},
        {name: t("total_online_queue"), value: TodayQueue.total_online_queue.count, color: "bg-success", detail_path: admin_today_queues_path}
      ]

      build_summary

      render "index"
    end

    def future
      @summary = [
        {name: t("total_future_queues"), value: TodayQueue.total_future_queue.count, color: "bg-dark", detail_path: admin_today_queues_path},
        {name: t("total_future_offline_queue"), value: TodayQueue.total_future_offline_queue.count, color: "bg-info", detail_path: admin_today_queues_path},
        {name: t("total_future_online_queue"), value: TodayQueue.total_future_online_queue.count, color: "bg-success", detail_path: admin_today_queues_path}
      ]

      build_summary

      render "index"
    end

    private

    def set_user_satisfaction_index_summary
      @pie_chart_date_user_satisfaction ||= SatisfactionIndex.all.map { |s| {name: s.name, y: total_user_satisfaction_index(s)} }.to_json.html_safe
    end

    def total_user_satisfaction_index(satisfaction_index)
      UserSatisfactionIndex.where("DATE(created_at) #{date_operator} ?", Date.today.to_s).where(satisfaction_index: satisfaction_index).count
    end

    def date_operator
      (@type == "today") ? "=" : ">"
    end

    def set_type
      @type ||= params[:type]
    end

    def set_summary_title
      @summary_title = t("#{@type}_queue")
      add_breadcrumb @summary_title
    end

    def build_summary
      @pie_chart_data_summary = @summary.map { |x| {name: x[:name], y: x[:value]} unless x[:skip_pie_chart] }.compact.to_json.html_safe
    end
  end
end
