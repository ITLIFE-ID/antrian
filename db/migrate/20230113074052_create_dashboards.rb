class CreateDashboards < ActiveRecord::Migration[7.0]
  def change
    create_table :dashboards do |t|
      t.belongs_to :company
      t.string :name
      t.bigint :total
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :dashboards, :deleted_at
  end
end
