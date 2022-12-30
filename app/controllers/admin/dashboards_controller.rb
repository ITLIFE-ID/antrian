# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

module Admin
  class DashboardsController < Admin::ApplicationController
    before_action :set_type, :set_summary_title
    before_action :set_user_satisfaction_index_summary
    add_breadcrumb "Dashboard"

    def index
      send(@type)
    end

    def past
      @online_vs_offline = [
        {name: t("total_offline_queue"), y: BackupQueue.total_offline_queue(start_date, end_date).count, color: "bg-info"},
        {name: t("total_online_queue"), y: BackupQueue.total_online_queue(start_date, end_date).count, color: "bg-success"}
      ]

      @summary = [
        {name: t("past_queue_performance"), y: "#{BackupQueue.performance(start_date, end_date)} antrian / menit", color: "bg-success"},
        {name: t("total_queues"), y: BackupQueue.total_queue(start_date, end_date).count, color: "bg-primary"}
      ] << @online_vs_offline

      @pie_chart = [{element: :online_vs_offline, data: @online_vs_offline}]

      render "index"
    end

    def today
      @online_vs_offline = [
        {name: t("total_offline_queue"), y: TodayQueue.total_offline_queue.count, color: "bg-info"},
        {name: t("total_online_queue"), y: TodayQueue.total_online_queue.count, color: "bg-success"}
      ]

      @processed_vs_unprocessed = [
        {name: t("total_processed"), y: TodayQueue.total_processed.count, color: "bg-primary"},
        {name: t("total_unprocessed"), y: TodayQueue.total_unprocessed.count, color: "bg-warning"}
      ]

      @summary = [
        {name: t("today_queue_performance"), y: "#{TodayQueue.performance} antrian / menit", color: "bg-dark"},
        {name: t("total_queues"), y: TodayQueue.total_queue.count, color: "bg-dark"}
      ] << @online_vs_offline << @processed_vs_unprocessed

      @pie_chart = [
        {element: :online_vs_offline, data: @online_vs_offline},
        {element: :processed_vs_unprocessed, data: @processed_vs_unprocessed}
      ]

      render "index"
    end

    def future
      @online_vs_offline = [
        {name: t("total_future_offline_queue"), y: TodayQueue.total_future_offline_queue.count, color: "bg-info"},
        {name: t("total_future_online_queue"), y: TodayQueue.total_future_online_queue.count, color: "bg-success"}
      ]

      @summary = [
        {name: t("total_future_queues"), y: TodayQueue.total_future_queue.count, color: "bg-dark"}
      ] << @online_vs_offline

      @pie_chart = [{element: :online_vs_offline, data: @online_vs_offline}]

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

    def start_date
      params[:start_date].present? ? Date.parse(params[:start_date]).strftime("%Y-%m-%d") : Date.today
    end

    def end_date
      params[:start_date].present? ? Date.parse(params[:end_date]).strftime("%Y-%m-%d") : Date.today
    end
  end
end
