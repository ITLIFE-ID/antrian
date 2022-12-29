class ModifyPlayList < ActiveRecord::Migration[7.0]
  def change
    remove_column :play_lists, :file_type, :string
    remove_column :play_lists, :title, :string
  end
end
