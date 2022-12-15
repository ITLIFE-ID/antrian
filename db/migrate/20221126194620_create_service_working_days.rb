# frozen_string_literal: true

class CreateServiceWorkingDays < ActiveRecord::Migration[7.0]
  def change
    create_table :service_working_days do |t|
      t.belongs_to :service
      t.integer :day
      t.time :open_time
      t.time :closing_time
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :service_working_days, :deleted_at
    add_index :service_working_days, [:day, :service_id], unique: true
  end
end
