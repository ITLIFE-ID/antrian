# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

module Admin
  class DashboardsController < Admin::ApplicationController
    add_breadcrumb "Dashboard"

    def past
      add_breadcrumb "Past"
      @summary_title = t("past_queue")

      @online_vs_offline = [
        {name: t("total_offline_queue"), y: BackupQueue.total_offline_queue(start_date, end_date, @current_company.services).count, color: "bg-info"},
        {name: t("total_online_queue"), y: BackupQueue.total_online_queue(start_date, end_date, @current_company.services).count, color: "bg-success"}
      ]

      @summary = [
        {name: t("past_queue_performance"), y: "#{BackupQueue.performance(start_date, end_date, @current_company.services)} antrian / menit", color: "bg-success"},
        {name: t("total_queues"), y: BackupQueue.total_queue(start_date, end_date, @current_company.services).count, color: "bg-primary"}
      ] << @online_vs_offline

      @pie_chart = [{element: :online_vs_offline, colors: "#17a2b8,#28a745", data: @online_vs_offline.map { |x| x.except(:color) }}]

      render "index"
    end

    def today
      add_breadcrumb "Today"
      @summary_title = t("today_queue")

      @online_vs_offline = [
        {name: t("total_offline_queue"), y: TodayQueue.total_offline_queue(@current_company.services).count, color: "bg-info"},
        {name: t("total_online_queue"), y: TodayQueue.total_online_queue(@current_company.services).count, color: "bg-success"}
      ]

      @processed_vs_unprocessed = [
        {name: t("total_processed"), y: TodayQueue.total_processed(@current_company.services).count, color: "bg-primary"},
        {name: t("total_unprocessed"), y: TodayQueue.total_unprocessed(@current_company.services).count, color: "bg-warning"}
      ]

      @summary = [
        {name: t("today_queue_performance"), y: "#{TodayQueue.performance(@current_company.services)} antrian / menit", color: "bg-dark"},
        {name: t("total_queues"), y: TodayQueue.total_queue(@current_company.services).count, color: "bg-dark"}
      ] << @online_vs_offline << @processed_vs_unprocessed

      @pie_chart = [
        {element: :online_vs_offline, colors: "#17a2b8,#28a745", data: @online_vs_offline.map { |x| x.except(:color) }},
        {element: :processed_vs_unprocessed, colors: "#007bff,#ffc107", data: @processed_vs_unprocessed.map { |x| x.except(:color) }}
      ]

      render "index"
    end

    def future
      add_breadcrumb "Future"
      @summary_title = t("future_queue")

      @online_vs_offline = [
        {name: t("total_future_offline_queue"), y: TodayQueue.total_future_offline_queue.count, color: "bg-info"},
        {name: t("total_future_online_queue"), y: TodayQueue.total_future_online_queue.count, color: "bg-success"}
      ]

      @summary = [
        {name: t("total_future_queues"), y: TodayQueue.total_future_queue.count, color: "bg-dark"}
      ] << @online_vs_offline

      @pie_chart = [{element: :online_vs_offline, colors: "#17a2b8,#28a745", data: @online_vs_offline.map { |x| x.except(:color) }}]

      render "index"
    end

    def user_satisfaction_indices
      render "user_satisfaction_indices"
    end

    private

    def set_user_satisfaction_index_summary
      @pie_chart_date_user_satisfaction ||= SatisfactionIndex.all.map { |s| {name: s.name, y: total_user_satisfaction_index(s)} }.to_json.html_safe
    end

    def start_date
      params[:start_date].present? ? Date.parse(params[:start_date]).strftime("%Y-%m-%d") : Date.today.to_s
    end

    def end_date
      params[:start_date].present? ? Date.parse(params[:end_date]).strftime("%Y-%m-%d") : Date.today.to_s
    end
  end
end
