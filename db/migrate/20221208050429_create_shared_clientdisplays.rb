# frozen_string_literal: true

class CreateSharedClientdisplays < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_clientdisplays do |t|
      t.references :clientdisplay_able, polymorphic: true
      t.belongs_to :client_display
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :shared_clientdisplays, :deleted_at
    add_index :shared_clientdisplays, [:clientdisplay_able_id, :clientdisplay_able_type], unique: true, name: :index_shared_clientdisplays_on_client_display
  end
end
