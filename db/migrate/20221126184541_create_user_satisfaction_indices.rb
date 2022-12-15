# frozen_string_literal: true

class CreateUserSatisfactionIndices < ActiveRecord::Migration[7.0]
  def change
    create_table :user_satisfaction_indices do |t|
      t.belongs_to :today_queue
      t.belongs_to :satisfaction_index
      t.string :satifcation_index_name
      t.string :officer_name
      t.integer :rating
      t.string :review

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :user_satisfaction_indices, :deleted_at
    add_index :user_satisfaction_indices, [:satisfaction_index_id, :today_queue_id], unique: true, name: :index_user_satisfaction_indices_on_satisfaction_and_queue
  end
end
