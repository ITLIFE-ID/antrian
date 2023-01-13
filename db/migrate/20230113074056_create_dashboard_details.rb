class CreateDashboardDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :dashboard_details do |t|
      t.belongs_to :dashboard
      t.date :date
      t.bigint :total
      t.timestamps
    end
  end
end
