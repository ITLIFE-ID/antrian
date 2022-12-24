# frozen_string_literal: true

class CreateClosingDays < ActiveRecord::Migration[7.0]
  def change
    create_table :closing_days do |t|
      t.references :closeable, polymorphic: true
      t.date :date
      t.datetime :start_time
      t.datetime :finish_time
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :closing_days, :deleted_at
    add_index :closing_days, [:date, :closeable_id, :closeable_type], unique: true
  end
end
