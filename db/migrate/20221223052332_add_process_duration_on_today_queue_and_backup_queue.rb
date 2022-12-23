class AddProcessDurationOnTodayQueueAndBackupQueue < ActiveRecord::Migration[7.0]
  def change
    add_column :today_queues, :process_duration, :integer
    add_column :backup_queues, :process_duration, :integer
  end
end
