class RenameColumnUniqNumberOnTodayQueues < ActiveRecord::Migration[7.0]
  def change
    rename_column :today_queues, :unique_number, :unique_number
    rename_column :backup_queues, :unique_number, :unique_number
  end
end
