class AddRegistrationOrderToPeople < ActiveRecord::Migration
  def change
    add_column :people, :registration_order, :integer, default: 0, null: false
  end
end
