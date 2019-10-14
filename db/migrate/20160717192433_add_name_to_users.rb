class AddNameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :name, :string
    User.update_all(name: :admin)
    change_column_null :users, :name, false
    add_index :users, :name, unique: true
  end
end
