class AddDashboardDetailIdToTodayAndBackUpQueue < ActiveRecord::Migration[7.0]
  def change
    add_reference :today_queues, :dashboard_detail, index: true
    add_reference :backup_queues, :dashboard_detail, index: true
  end
end
