# frozen_string_literal: true

class CreateCompanyClosingDays < ActiveRecord::Migration[7.0]
  def change
    create_table :company_closing_days do |t|
      t.belongs_to :company
      t.date :date
      t.datetime :start_time
      t.datetime :finish_time
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :company_closing_days, :deleted_at
    add_index :company_closing_days, [:date, :company_id], unique: true
  end
end
