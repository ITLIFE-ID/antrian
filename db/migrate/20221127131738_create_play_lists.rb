# frozen_string_literal: true

class CreatePlayLists < ActiveRecord::Migration[7.0]
  def change
    create_table :play_lists do |t|
      t.belongs_to :client_display
      t.string :title
      t.string :file_type
      t.boolean :playing, default: false

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :play_lists, :deleted_at
  end
end
