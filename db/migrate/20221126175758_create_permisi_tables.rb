# frozen_string_literal: true

class CreatePermisiTables < ActiveRecord::Migration[7.0]
  def up
    create_table :permisi_actors do |t|
      t.references :aka, polymorphic: true
      t.timestamps
      t.datetime :deleted_at
    end

    create_table :permisi_roles do |t|
      t.string :slug, null: false, unique: true
      t.string :name, null: false, unique: true
      t.json :permissions
      t.timestamps
      t.datetime :deleted_at
    end

    create_table :permisi_actor_roles do |t|
      t.belongs_to :actor
      t.belongs_to :role
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :permisi_actor_roles, %i[actor_id role_id], unique: true
    add_index :permisi_actors, :deleted_at
    add_index :permisi_roles, :deleted_at
    add_index :permisi_actor_roles, :deleted_at
    add_index :permisi_actors, %i[aka_type aka_id]
  end

  def down
    drop_table :permisi_actor_roles
    drop_table :permisi_roles
    drop_table :permisi_actors
  end
end
