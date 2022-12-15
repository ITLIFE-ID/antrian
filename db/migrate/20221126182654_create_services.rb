# frozen_string_literal: true

class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.belongs_to :company
      t.belongs_to :service_type
      t.belongs_to :parent, default: 0
      t.string :name
      t.string :letter
      t.boolean :priority, default: 0
      t.boolean :active, default: true
      t.integer :max_quota
      t.boolean :closed, default: false
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :services, :deleted_at
    add_index :services, [:letter, :company_id], unique: true
  end
end
