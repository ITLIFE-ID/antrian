# frozen_string_literal: true

class CreateCounterClientDisplays < ActiveRecord::Migration[7.0]
  def change
    create_table :counter_client_displays do |t|
      t.belongs_to :counter
      t.belongs_to :client_display
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :counter_client_displays, :deleted_at
    add_index :counter_client_displays, [:counter_id, :client_display_id], unique: true, name: :index_counter_client_displays_on_counter_and_client_display
  end
end
