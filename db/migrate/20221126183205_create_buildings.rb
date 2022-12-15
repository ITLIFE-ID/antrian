# frozen_string_literal: true

class CreateBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.belongs_to :company
      t.string :name
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :buildings, :deleted_at
    add_index :buildings, [:company_id, :name], unique: true
  end
end
