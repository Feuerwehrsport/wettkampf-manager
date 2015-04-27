class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.integer :gender, null: false
      t.references :team, index: true

      t.timestamps null: false
    end
  end
end
