# frozen_string_literal: true

class CreateCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :counters do |t|
      t.belongs_to :service
      t.integer :number, default: 0
      t.boolean :closed, default: false
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :counters, :deleted_at
    add_index :counters, [:number, :service_id], unique: true
  end
end
