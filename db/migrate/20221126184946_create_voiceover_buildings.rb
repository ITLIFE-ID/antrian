# frozen_string_literal: true

class CreateVoiceoverBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :voiceover_buildings do |t|
      t.belongs_to :building
      t.belongs_to :voice_over
      t.integer :day
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :voiceover_buildings, :deleted_at
    add_index :voiceover_buildings, [:voice_over_id, :building_id, :day], unique: true, name: :index_voiceover_buildings_on_voice_over_and_building_and_day
  end
end
