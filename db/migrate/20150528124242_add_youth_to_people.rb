class AddYouthToPeople < ActiveRecord::Migration
  def change
    add_column :people, :youth, :boolean, default: false, null: false
  end
end
