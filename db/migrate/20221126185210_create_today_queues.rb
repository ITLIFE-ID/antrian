# frozen_string_literal: true

class CreateTodayQueues < ActiveRecord::Migration[7.0]
  def change
    create_table :today_queues do |t|
      t.belongs_to :parent
      t.belongs_to :counter
      t.belongs_to :service

      t.date :date
      t.string :letter
      t.integer :number
      t.string :service_type_slug
      t.datetime :print_ticket_time
      t.string :print_ticket_location
      t.string :print_ticket_method

      t.datetime :start_time
      t.datetime :finish_time
      t.boolean :priority, default: false

      t.string :uniq_number
      t.boolean :attend, default: false
      t.string :note
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :today_queues, :deleted_at
    add_index :today_queues, [:number, :date, :service_id, :letter], unique: true
  end
end
