# frozen_string_literal: true

class CreateVoiceOvers < ActiveRecord::Migration[7.0]
  def change
    create_table :voice_overs do |t|
      t.string :name
      t.string :slug
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :voice_overs, :deleted_at
    add_index :voice_overs, :name, unique: true
  end
end
