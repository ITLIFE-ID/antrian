# frozen_string_literal: true

class CreateSatisfactionIndices < ActiveRecord::Migration[7.0]
  def change
    create_table :satisfaction_indices do |t|
      t.belongs_to :company
      t.string :name
      t.integer :order_number
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :satisfaction_indices, :deleted_at
    add_index :satisfaction_indices, [:name, :company_id], unique: true
    add_index :satisfaction_indices, [:order_number, :company_id], unique: true
  end
end
