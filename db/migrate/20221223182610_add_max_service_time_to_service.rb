class AddMaxServiceTimeToService < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :max_service_time, :integer
  end
end
