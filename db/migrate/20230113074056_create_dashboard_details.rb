class CreateDashboardDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :dashboard_details do |t|
      t.belongs_to :company
      t.belongs_to :dashboard
      t.date :date
      t.bigint :total
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :dashboard_details, :deleted_at
  end
end
