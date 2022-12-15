# frozen_string_literal: true

class CreateServiceClientdisplays < ActiveRecord::Migration[7.0]
  def change
    create_table :service_clientdisplays do |t|
      t.belongs_to :service
      t.belongs_to :client_display
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :service_clientdisplays, :deleted_at
    add_index :service_clientdisplays, [:service_id, :client_display_id], unique: true, name: :index_service_clientdisplays_on_service_and_client_display
  end
end
