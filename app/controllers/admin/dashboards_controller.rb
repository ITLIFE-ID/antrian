# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

# app/controllers/admin/stats_controller.rb
module Admin
  class DashboardsController < Admin::ApplicationController    
    add_breadcrumb "Dashboard"

    def past
      @type = "past"
      @summary_title = t("past_queue")
      add_breadcrumb @summary_title

      @performance_title = t("past_queue_performance")
      @user_satisfaction_title = t("past_queue_user_satisfaction")      

      @user_satisfaction = [
        {name: t("total_queues"), value: BackupQueue.count, color: "bg-dark", detail_path: admin_today_queues_path},
        {name: t("total_offline_queue"), value: BackupQueue.total_offline_queue.count, color: "bg-info", detail_path: admin_today_queues_path},
        {name: t("total_online_queue"), value: BackupQueue.total_online_queue.count, color: "bg-success", detail_path: admin_today_queues_path}
      ]

      @summary = [
        {name: t("total_queues"), value: BackupQueue.count, color: "bg-primary", detail_path: admin_today_queues_path},
        {name: t("total_offline_queue"), value: BackupQueue.total_offline_queue.count, color: "bg-info", detail_path: admin_today_queues_path},
        {name: t("total_online_queue"), value: BackupQueue.total_online_queue.count, color: "bg-success", detail_path: admin_today_queues_path}
      ]

      render "index"
    end

    def today
      @type = "today"
      @summary_title = t("today_queue")
      add_breadcrumb @summary_title

      @performance_title = t("today_queue_performance")
      @user_satisfaction_title = t("today_queue_user_satisfaction")

      @user_satisfaction = [
        {name: t("total_queues"), value: TodayQueue.total_queue.count, color: "bg-dark", detail_path: admin_today_queues_path},
        {name: t("total_processed"), value: TodayQueue.total_processed.count, color: "bg-primary", detail_path: admin_today_queues_path},
        {name: t("total_unprocessed"), value: TodayQueue.total_unprocessed.count, color: "bg-warning", detail_path: admin_today_queues_path},
        {name: t("total_offline_queue"), value: TodayQueue.total_offline_queue.count, color: "bg-info", detail_path: admin_today_queues_path},
        {name: t("total_online_queue"), value: TodayQueue.total_online_queue.count, color: "bg-success", detail_path: admin_today_queues_path}
      ]

      @summary = [
        {name: t("total_queues"), value: TodayQueue.total_queue.count, color: "bg-dark", detail_path: admin_today_queues_path},
        {name: t("total_processed"), value: TodayQueue.total_processed.count, color: "bg-primary", detail_path: admin_today_queues_path},
        {name: t("total_unprocessed"), value: TodayQueue.total_unprocessed.count, color: "bg-warning", detail_path: admin_today_queues_path},
        {name: t("total_offline_queue"), value: TodayQueue.total_offline_queue.count, color: "bg-info", detail_path: admin_today_queues_path},
        {name: t("total_online_queue"), value: TodayQueue.total_online_queue.count, color: "bg-success", detail_path: admin_today_queues_path}
      ]

      render "index"
    end

    def future
      @type = "future"
      @summary_title = t("future_queue")  
      add_breadcrumb @summary_title          

      @summary = [
        {name: t("total_future_queues"), value: TodayQueue.total_future_queue.count, color: "bg-dark", detail_path: admin_today_queues_path},
        {name: t("total_future_offline_queue"), value: TodayQueue.total_future_offline_queue.count, color: "bg-info", detail_path: admin_today_queues_path},
        {name: t("total_future_online_queue"), value: TodayQueue.total_future_online_queue.count, color: "bg-success", detail_path: admin_today_queues_path}
      ]

      render "index"
    end
  end
end