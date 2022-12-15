# frozen_string_literal: true

class CreateServiceBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :service_buildings do |t|
      t.belongs_to :service
      t.belongs_to :building
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :service_buildings, :deleted_at
    add_index :service_buildings, [:service_id, :building_id], unique: true
  end
end
