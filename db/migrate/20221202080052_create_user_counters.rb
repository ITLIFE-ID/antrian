# frozen_string_literal: true

class CreateUserCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :user_counters do |t|
      t.belongs_to :user
      t.belongs_to :counter
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :user_counters, :deleted_at
    add_index :user_counters, [:user_id, :counter_id], unique: true
  end
end
