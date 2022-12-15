# frozen_string_literal: true

class CreateServiceClosingDays < ActiveRecord::Migration[7.0]
  def change
    create_table :service_closing_days do |t|
      t.belongs_to :service
      t.date :date
      t.datetime :start_time
      t.datetime :finish_time
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :service_closing_days, :deleted_at
    add_index :service_closing_days, [:date, :service_id], unique: true
  end
end
