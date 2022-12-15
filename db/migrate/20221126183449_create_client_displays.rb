# frozen_string_literal: true

class CreateClientDisplays < ActiveRecord::Migration[7.0]
  def change
    create_table :client_displays do |t|
      t.belongs_to :building
      t.string :client_display_type
      t.string :ip_address
      t.string :location
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :client_displays, :deleted_at
    add_index :client_displays, [:ip_address, :building_id], unique: true
  end
end
