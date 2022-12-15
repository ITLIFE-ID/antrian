# frozen_string_literal: true

class CreateCompanyWorkingDays < ActiveRecord::Migration[7.0]
  def change
    create_table :company_working_days do |t|
      t.belongs_to :company
      t.integer :day
      t.time :open_time
      t.time :closing_time
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :company_working_days, :deleted_at
    add_index :company_working_days, [:day, :company_id], unique: true
  end
end
