# app/dashboards/stat_dashboard.rb
require "administrate/custom_dashboard"

# app/controllers/admin/stats_controller.rb
module Admin
  class DashboardsController < Admin::ApplicationController
    def past
      @summary = [
        {name: :total_queues, value: BackupQueue.total_queue, color: "bg-primary"},
        {name: :total_offline_queue, value: BackupQueue.total_offline_queue, color: "bg-info"},
        {name: :total_online_queue, value: BackupQueue.total_online_queue, color: "bg-success"}
      ]

      render "index"
    end

    def today
      @summary = [
        {name: :total_queues, value: TodayQueue.total_queue, color: "bg-primary"},
        {name: :total_processed, value: TodayQueue.total_processed, color: "bg-success"},
        {name: :total_unprocessed, value: TodayQueue.total_unprocessed, color: "bg-warning"},
        {name: :total_offline_queue, value: TodayQueue.total_offline_queue, color: "bg-info"},
        {name: :total_online_queue, value: TodayQueue.total_online_queue, color: "bg-success"}
      ]

      render "index"
    end

    def future
      @summary = [
        {name: :total_future_queues, value: TodayQueue.total_future_queue, color: "bg-primary"},
        {name: :total_future_offline_queue, value: TodayQueue.total_future_offline_queue, color: "bg-info"},
        {name: :total_future_online_queue, value: TodayQueue.total_future_online_queue, color: "bg-success"}
      ]

      render "index"
    end
  end
end