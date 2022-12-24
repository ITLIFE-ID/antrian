# frozen_string_literal: true

class CreateWorkingDays < ActiveRecord::Migration[7.0]
  def change
    create_table :working_days do |t|
      t.references :workable, polymorphic: true
      t.integer :day
      t.time :open_time
      t.time :closing_time
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :working_days, :deleted_at
    add_index :working_days, [:day, :workable_id, :workable_type], unique: true
  end
end
