# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

# app/controllers/admin/stats_controller.rb
module Admin
  class DashboardsController < Admin::ApplicationController
    def past
      @summary_title = t("past_queue")
      @performance_title = t("past_queue_performance")
      @user_satisfaction_title = t("past_queue_user_satisfaction")
      
      @performance = [
        {name: t("total_queues"), value: BackupQueue.count, color: "bg-dark"},
        {name: t("total_offline_queue"), value: BackupQueue.total_offline_queue.count, color: "bg-info"},
        {name: t("total_online_queue"), value: BackupQueue.total_online_queue.count, color: "bg-success"}
      ]

      @user_satisfaction = [
        {name: t("total_queues"), value: BackupQueue.count, color: "bg-dark"},
        {name: t("total_offline_queue"), value: BackupQueue.total_offline_queue.count, color: "bg-info"},
        {name: t("total_online_queue"), value: BackupQueue.total_online_queue.count, color: "bg-success"}
      ]

      @summary = [
        {name: t("total_queues"), value: BackupQueue.count, color: "bg-primary"},
        {name: t("total_offline_queue"), value: BackupQueue.total_offline_queue.count, color: "bg-info"},
        {name: t("total_online_queue"), value: BackupQueue.total_online_queue.count, color: "bg-success"}
      ]

      render "index"
    end

    def today
      @summary_title = t("today_queue")
      @performance_title = t("today_queue_performance")
      @user_satisfaction_title = t("today_queue_user_satisfaction")

      @performance = [
        {name: t("total_queues"), value: TodayQueue.total_queue.count, color: "bg-dark"},
        {name: t("total_processed"), value: TodayQueue.total_processed.count, color: "bg-primary"},
        {name: t("total_unprocessed"), value: TodayQueue.total_unprocessed.count, color: "bg-warning"},
        {name: t("total_offline_queue"), value: TodayQueue.total_offline_queue.count, color: "bg-info"},
        {name: t("total_online_queue"), value: TodayQueue.total_online_queue.count, color: "bg-success"}
      ]

      @user_satisfaction = [
        {name: t("total_queues"), value: TodayQueue.total_queue.count, color: "bg-dark"},
        {name: t("total_processed"), value: TodayQueue.total_processed.count, color: "bg-primary"},
        {name: t("total_unprocessed"), value: TodayQueue.total_unprocessed.count, color: "bg-warning"},
        {name: t("total_offline_queue"), value: TodayQueue.total_offline_queue.count, color: "bg-info"},
        {name: t("total_online_queue"), value: TodayQueue.total_online_queue.count, color: "bg-success"}
      ]

      @summary = [
        {name: t("total_queues"), value: TodayQueue.total_queue.count, color: "bg-dark"},
        {name: t("total_processed"), value: TodayQueue.total_processed.count, color: "bg-primary"},
        {name: t("total_unprocessed"), value: TodayQueue.total_unprocessed.count, color: "bg-warning"},
        {name: t("total_offline_queue"), value: TodayQueue.total_offline_queue.count, color: "bg-info"},
        {name: t("total_online_queue"), value: TodayQueue.total_online_queue.count, color: "bg-success"}
      ]

      render "index"
    end

    def future
      @summary_title = t("future_queue")      

      @summary = [
        {name: t("total_future_queues"), value: TodayQueue.total_future_queue.count, color: "bg-dark"},
        {name: t("total_future_offline_queue"), value: TodayQueue.total_future_offline_queue.count, color: "bg-info"},
        {name: t("total_future_online_queue"), value: TodayQueue.total_future_online_queue.count, color: "bg-success"}
      ]

      render "index"
    end
  end
end