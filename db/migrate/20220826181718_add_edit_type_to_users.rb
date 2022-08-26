class AddEditTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :edit_type, :integer, default: 0, null: false
  end
end
