# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :latitude
      t.string :longitude
      t.string :api_key

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :companies, :deleted_at
    add_index :companies, :name, unique: true
  end
end
