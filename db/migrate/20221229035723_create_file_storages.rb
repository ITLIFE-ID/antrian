class CreateFileStorages < ActiveRecord::Migration[7.0]
  def change
    create_table :file_storages do |t|
      t.references :file_able, polymorphic: true
      t.belongs_to :company
      t.string :title
      t.string :file_type
      t.datetime :deleted_at
    end
  end
end
