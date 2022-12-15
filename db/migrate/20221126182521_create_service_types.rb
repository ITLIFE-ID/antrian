# frozen_string_literal: true

class CreateServiceTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :service_types do |t|
      t.belongs_to :company
      t.string :name
      t.string :slug
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :service_types, :deleted_at
    add_index :service_types, [:company_id, :name], unique: true
  end
end
