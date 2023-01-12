# frozen_string_literal: true

class CreateBackupQueues < ActiveRecord::Migration[7.0]
  def change
    create_table :backup_queues do |t|
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

      t.string :unique_number
      t.boolean :attend, default: false
      t.string :note
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :backup_queues, :deleted_at
    add_index :backup_queues, [:number, :date, :service_id, :letter], unique: true, name: :index_backup_queues_on_number_and_date_and_service_and_letter
  end
end
